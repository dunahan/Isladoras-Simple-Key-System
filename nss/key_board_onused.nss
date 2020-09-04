#include "_key_include"
string s = "key_board_onused: ";

void main()
{
  object oKeyBoard = OBJECT_SELF;                                               DebugMode(s+GetName(oKeyBoard));
  string sDoorsWithKeys;

  if (GetLocalInt(oKeyBoard, KEYSYS_DOORLINI) == TRUE)
    ActionStartConversation(GetLastUsedBy());

  else
  {
    sDoorsWithKeys = CreateKeyList(GetArea(oKeyBoard));                         DebugMode(s+sDoorsWithKeys);

    SetLocalInt(oKeyBoard, KEYSYS_DOORLINI, TRUE);                              DebugMode(s+"Init done!");
    SetLocalString(oKeyBoard, KEYSYS_DOORKEYS, sDoorsWithKeys);                 DebugMode(s+"Save Doors to local string.\n"+GetLocalString(oKeyBoard, KEYSYS_DOORKEYS));
    SetLocalString(oKeyBoard, KEYSYS_DOORKEYS+"_ORG", sDoorsWithKeys);
    SetDescription(oKeyBoard, sDoorsWithKeys, TRUE);                            DebugMode(s+"Save it to description for Debug.");

    ActionStartConversation(GetLastUsedBy());
  }
}
