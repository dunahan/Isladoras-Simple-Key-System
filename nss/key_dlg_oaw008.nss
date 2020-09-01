#include "_key_include"
string s = "key_dlg_oaw008: ";

int StartingConditional()
{
  if (GetTokenCount(GetLocalString(OBJECT_SELF, KEYSYS_DOORKEYS)) > 6)
    return TRUE;

  return FALSE;
}
