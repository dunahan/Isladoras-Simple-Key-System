void DebugMode(string sDebug);
void DebugMode(string sDebug)
{
  int DEBUG_MODE = GetLocalInt(GetModule(), "DEBUG_MODE");

       if (DEBUG_MODE == TRUE)
    SpeakString(sDebug, TALKVOLUME_SHOUT);

  else if (DEBUG_MODE == 2)
    WriteTimestampedLogEntry(sDebug);

  else if (DEBUG_MODE == 3)
  {
    SpeakString(sDebug, TALKVOLUME_SHOUT);
    WriteTimestampedLogEntry(sDebug);
  }
}

void SendServerMessageToPC(object oPlayer, string szMessage)
{
    SendMessageToPC(oPlayer, "[Server] "+szMessage);
}
