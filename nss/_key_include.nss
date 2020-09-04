#include "x2_inc_itemprop"
#include "x3_inc_string"

#include "_tokenizer_inc"
#include "_debugisla"

const int    KEYSYS_FEEPDAYS = 100;

const string KEYSYS_TEMPLATE = "key_template";
const string KEYSYS_ULTIMATE = "key_ultimate";
const string KEYSYS_DIALOGUE = "key_board";
const string KEYSYS_DOORKEYS = "KEY_DOORS";
const string KEYSYS_DOORSFEE = "KEYFEE";
const string KEYSYS_DOORLINI = "KEYI";
const string KEYSYS_DOORRENT = "key_rented";

const string KEYSYS_ERROR001 = "DM:  There is no target, to create a key.";
const string KEYSYS_BOARD001 = "Here are more keys you can borrow. But it will cost you a fee per day.";
const string KEYSYS_BOARD002 = "There are no keys left on this board, thus all rooms are rented.";
const string KEYSYS_BOARD003 = "You do't have ennough gold to pay the fee. So you have to keep it, until you have enough.";
const string KEYSYS_BOARD004 = "Return key to ";

// Returns current game-time in seconds.
int CalcCurrent()
{
    int iYear   = GetCalendarYear();
    int iMonth  = GetCalendarMonth();
    int iDay    = GetCalendarDay();
    int iHour   = GetTimeHour();
    int iMinute = GetTimeMinute();
    int iSecond = GetTimeSecond();
    int iSecondsPerHour = FloatToInt(HoursToSeconds(1));

    return     iYear  * 12 * 28 * 24 * iSecondsPerHour
            + (iMonth - 1) * 28 * 24 * iSecondsPerHour
            + (iDay - 1)        * 24 * iSecondsPerHour
            +  iHour                 * iSecondsPerHour
            +  iMinute                    * 60
            +  iSecond;
}

int CalcActualDays()
{
    int iYear   = GetCalendarYear();
    int iMonth  = GetCalendarMonth();
    int iDay    = GetCalendarDay();

    return    iYear  * 12 * 28 * 24
           + (iMonth - 1) * 28 * 24
           + (iDay   - 1)      * 24;
}

string CreateKeyList(object oArea)
{
  string sResult = "";
  object oObject = GetFirstObjectInArea(oArea);
  while (GetIsObjectValid(oObject))
  {
    if (GetObjectType(oObject) == OBJECT_TYPE_DOOR
    &&  GetLockKeyTag(oObject) != ""
    &&  GetLocalInt(oObject, KEYSYS_DOORRENT) != 1)
       sResult = AddTokenToString(GetLockKeyTag(oObject), sResult);
    oObject = GetNextObjectInArea(oArea);
  }

  if (sResult == "")
    return "Error";

  return sResult;
}

object GetDoorByKeyTag(string sKeyTag, object oArea)
{
  object oObject = GetFirstObjectInArea(oArea);
  while (GetIsObjectValid(oObject))
  {
    if (GetObjectType(oObject) == OBJECT_TYPE_DOOR && GetLockKeyTag(oObject) == sKeyTag)
      return oObject;
    oObject = GetNextObjectInArea(oArea);
  }
  return OBJECT_INVALID;
}

int CalcFee(object oKey, object oPC)
{
  object oDoor = GetDoorByKeyTag(GetTag(oKey), GetArea(oPC));
  int nFee = CalcActualDays() - GetLocalInt(oKey, KEYSYS_DOORSFEE);
  nFee = (nFee / 24) * KEYSYS_FEEPDAYS;

  return nFee;
}

void CalcFeeAndTakeIt(object oKey, object oPC)
{
  object oDoor = GetDoorByKeyTag(GetTag(oKey), GetArea(oPC));
  int nFee = CalcActualDays() - GetLocalInt(oKey, KEYSYS_DOORSFEE);
  nFee = (nFee / 24) * KEYSYS_FEEPDAYS;

  if (GetGold(oPC) >= nFee) // if more than seconds ran away, minutes for example, take a fee.
  {
    TakeGoldFromCreature(nFee, oPC, TRUE);
    DestroyObject(oKey);
    ActionDoCommand(ActionCloseDoor(oDoor));
    ActionDoCommand(SetLocked(oDoor, TRUE));
  }

  else   // you dont have any gold! you can't pay the rent, so you have to keep it!
    SendMessageToPC(oPC, KEYSYS_BOARD003);
}
