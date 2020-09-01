#include "_key_include"
string s = "key_dlg_oaw001: ";

int StartingConditional()
{
  object oKeyBoard = OBJECT_SELF;                                               //DebugMode(s+GetName(oKeyBoard));
  string sDoorsWithKeys = GetLocalString(oKeyBoard, KEYSYS_DOORKEYS);           //DebugMode(s+sDoorsWithKeys);
  if (GetTokenCount(sDoorsWithKeys)> 0)                                         //DebugMode(s+IntToString(t));
    SetCustomToken(500, KEYSYS_BOARD001);
  else
    SetCustomToken(500, KEYSYS_BOARD002);

  return TRUE;
}
