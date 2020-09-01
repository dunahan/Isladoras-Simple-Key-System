#include "x2_inc_itemprop"
#include "x3_inc_string"

#include "_tokenizer_inc"
#include "_debugisla"

const int    KEYSYS_FEEPDAYS = 100;
const int    KEYSYS_FEEPHOUR = 10;
const int    KEYSYS_FEEPMINT = 5;

const string KEYSYS_TEMPLATE = "key_template";
const string KEYSYS_ULTIMATE = "key_ultimate";
const string KEYSYS_DIALOGUE = "key_board";
const string KEYSYS_DOORKEYS = "KEY_DOORS";
const string KEYSYS_DOORSFEE = "KEYFEE";
const string KEYSYS_DOORLINI = "KEYI";

const string KEYSYS_BOARD001 = "Here are more keys you can borrow. But it will cost you a fee per day.";
const string KEYSYS_BOARD002 = "There are no keys left on this board, thus all rooms are rented.";
const string KEYSYS_BOARD003 = "You do't have ennough gold to pay the fee. So you have to keep it, until you have enough.";

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

void CalcFeeAndTakeIt(object oKey, object oPC)
{
  object oDoor = GetDoorByKeyTag(GetTag(oKey), GetArea(oPC));

  int nFee = CalcCurrent() - GetLocalInt(oKey, KEYSYS_DOORSFEE);
  int bFee = 1;

  if (nFee > 60)
  {
    nFee = (nFee / 60) * KEYSYS_FEEPMINT;
    bFee = 2;
  }

  if (nFee > 60)
  {
    nFee = (nFee / 60) * KEYSYS_FEEPHOUR;
    bFee = 3;
  }

  if (nFee > 60)
  {
    nFee = (nFee / 24) * KEYSYS_FEEPDAYS;
    bFee = 4;
  }


  if (bFee == 1)  // dont take any fee, if player has choosen the wrong one (only seconds)
  {
    DestroyObject(oKey);
    ActionDoCommand(ActionCloseDoor(oDoor));
    ActionDoCommand(SetLocked(oDoor, TRUE));
  }

  else if (GetGold(oPC) >= nFee && bFee >= 2) // if more than seconds ran away, minutes for example, take a fee.
  {
    TakeGoldFromCreature(nFee, oPC, TRUE);
    DestroyObject(oKey);
    ActionDoCommand(ActionCloseDoor(oDoor));
    ActionDoCommand(SetLocked(oDoor, TRUE));
  }

  else   // you dont have any gold! you can't pay the rent, so you have to keep it!
    SendMessageToPC(oPC, KEYSYS_BOARD003);
}
