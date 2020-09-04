int StartingConditional()
{
  if (GetIsDM(GetPCSpeaker()) || GetIsDMPossessed(GetPCSpeaker()))
    return TRUE;

  return FALSE;
}
