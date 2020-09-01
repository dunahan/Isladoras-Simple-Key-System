#include "_key_include"
string s = "key_board_onused: ";

void main()
{
  object oKeyBoard = OBJECT_SELF;                                               //DebugMode(s+GetName(oKeyBoard));

  object oObject = GetFirstObjectInArea();                                      //DebugMode(s+GetName(oObject));
  string sDoorsWithKeys;                                                        //DebugMode(s+sDoorsWithKeys);

  if (GetLocalInt(oKeyBoard, KEYSYS_DOORLINI) == TRUE)
  {
    ActionStartConversation(GetLastUsedBy());                                   //DebugMode(s+"Is Init done? "+GetLocalString(oKeyBoard, KEYSYS_DOORLINI));
  }

  else
  {
    while (GetIsObjectValid(oObject))
    {
      if (GetObjectType(oObject) == OBJECT_TYPE_DOOR && GetLockKeyTag(oObject) != "")
        sDoorsWithKeys = AddTokenToString(GetLockKeyTag(oObject), sDoorsWithKeys);  //DebugMode(s+sDoorsWithKeys);
      oObject = GetNextObjectInArea();                                          //DebugMode(s+GetName(oObject));
    }

    SetLocalInt(oKeyBoard, KEYSYS_DOORLINI, TRUE);                              //DebugMode(s+"Init done!");
    SetLocalString(oKeyBoard, KEYSYS_DOORKEYS, sDoorsWithKeys);                 //DebugMode(s+"Save Doors to local string.\n"+GetLocalString(oKeyBoard, KEYSYS_DOORKEYS));
    SetLocalString(oKeyBoard, KEYSYS_DOORKEYS+"_ORG", sDoorsWithKeys);
    SetDescription(oKeyBoard, sDoorsWithKeys, TRUE);                            //DebugMode(s+"Save it to description for Debug.");

    ActionStartConversation(GetLastUsedBy());
  }
}
