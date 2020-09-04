#include "_key_include"
string s = "key_dlg_oat005: ";
int n = 504;

void main()
{
  object oKeyBoard = OBJECT_SELF, oKey = GetItemPossessedBy(GetPCSpeaker(), GetLocalString(oKeyBoard, IntToString(n)));
  string sKeyTag = GetLocalString(oKeyBoard, IntToString(n)), sDoor = GetName(GetDoorByKeyTag(sKeyTag, GetArea(oKeyBoard))), sDoorsWithKeys;

  if (GetIsObjectValid(oKey))
  {
    sDoorsWithKeys = AddTokenToString(GetTag(oKey), GetLocalString(oKeyBoard, KEYSYS_DOORKEYS));
    SetLocalString(oKeyBoard, KEYSYS_DOORKEYS, sDoorsWithKeys);
    SetDescription(oKeyBoard, sDoorsWithKeys, TRUE);

    CalcFeeAndTakeIt(oKey, GetPCSpeaker());
  }

  else
  {
    oKey = CreateItemOnObject(KEYSYS_TEMPLATE, GetPCSpeaker(), 1, sKeyTag);
    SetLocalInt(oKey, KEYSYS_DOORSFEE, CalcActualDays());
    //SetName(oKey, StringReplace(sKeyTag, "_", " "));
    SetName(oKey, GetName(GetArea(oKeyBoard)) + " " + sDoor);

    sDoorsWithKeys = DeleteTokenFromString(sKeyTag, GetLocalString(oKeyBoard, KEYSYS_DOORKEYS));
    SetLocalString(oKeyBoard, KEYSYS_DOORKEYS, sDoorsWithKeys);
    SetDescription(oKeyBoard, sDoorsWithKeys, TRUE);
  }
}
