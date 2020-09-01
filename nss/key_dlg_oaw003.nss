#include "_key_include"
string s = "key_dlg_oaw003: ";

int StartingConditional()
{
  object oKeyBoard = OBJECT_SELF;
  string sDoorsWithKeys = GetLocalString(oKeyBoard, KEYSYS_DOORKEYS);
  int i, t = GetTokenCount(sDoorsWithKeys);

  if (GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(), GetLocalString(oKeyBoard, IntToString(502)))))
  {
    SetCustomToken(502, "Add "+StringReplace(GetLocalString(oKeyBoard, IntToString(502)), "_", " "));
    return TRUE;
  }

  if (t == 0)
    return FALSE;

  for (i = 1; i <= t; i++)
  {
    if (FindSubString(sDoorsWithKeys, GetLocalString(oKeyBoard, IntToString(502))) == -1)
      return FALSE;
  }

  return TRUE;
}
