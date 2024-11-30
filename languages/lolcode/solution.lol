HAI 1.4
  CAN HAS STDIO?

  I HAS A filename
  I HAS A part

  GIMMEH filename
  GIMMEH part

  HOW IZ I readline YR file
    I HAS A line ITZ ""
    IM IN YR loop
      I HAS A char ITZ I IZ STDIO'Z LUK YR file AN YR 1 MKAY
      BOTH SAEM char AN ":)"
      O RLY?
        YA RLY, FOUND YR line
      MEBBE BOTH SAEM char AN ""
        FOUND YR FAIL
      NO WAI
        line R SMOOSH line AN char MKAY
      OIC
    IM OUTTA YR loop
  IF U SAY SO

  I HAS A file ITZ I IZ STDIO'Z OPEN YR filename AN YR "r" MKAY
  I HAS A lines ITZ 0
  IM IN YR loop
    I HAS A line ITZ I IZ readline YR file MKAY
    BOTH SAEM line AN FAIL
    O RLY?
      YA RLY, GTFO
    OIC
    lines R SUM OF lines AN 1
  IM OUTTA YR loop
  I IZ STDIO'Z CLOSE YR file MKAY

  VISIBLE "Received " AN lines AN " lines of input for part " AN part
KTHXBYE
