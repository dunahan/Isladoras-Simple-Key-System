#include "_key_include"
string s = "key_dlg_oat006: ";

void main()
{
  object oKeyBoard = OBJECT_SELF, oKey = GetItemPossessedBy(GetPCSpeaker(), GetLocalString(oKeyBoard, IntToString(501)));
  string sKeyTag = GetLocalString(oKeyBoard, IntToString(505)), sDoorsWithKeys;
  int nFee;

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
    SetLocalInt(oKey, KEYSYS_DOORSFEE, CalcCurrent());
    SetName(oKey, StringReplace(sKeyTag, "_", " "));

    sDoorsWithKeys = DeleteTokenFromString(sKeyTag, GetLocalString(oKeyBoard, KEYSYS_DOORKEYS));
    SetLocalString(oKeyBoard, KEYSYS_DOORKEYS, sDoorsWithKeys);
    SetDescription(oKeyBoard, sDoorsWithKeys, TRUE);
  }
}
