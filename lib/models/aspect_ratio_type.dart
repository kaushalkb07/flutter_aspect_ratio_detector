enum AspectRatioType {
  RATIO_1_1,
  RATIO_4_3,
  RATIO_3_2,
  RATIO_3_4,
  RATIO_16_9,
  RATIO_21_9,
  RATIO_18_9,
  RATIO_9_16,
  RATIO_2_1,
  RATIO_5_4,
  RATIO_17_9,
  RATIO_2_35_1,
  MIX,
}

extension AspectRatioLabel on AspectRatioType {
  String get label {
    switch (this) {
      case AspectRatioType.RATIO_1_1:
        return "1:1";
      case AspectRatioType.RATIO_4_3:
        return "4:3";
      case AspectRatioType.RATIO_3_2:
        return "3:2";
      case AspectRatioType.RATIO_3_4:
        return "3:4";
      case AspectRatioType.RATIO_16_9:
        return "16:9";
      case AspectRatioType.RATIO_21_9:
        return "21:9";
      case AspectRatioType.RATIO_18_9:
        return "18:9";
      case AspectRatioType.RATIO_9_16:
        return "9:16";
      case AspectRatioType.RATIO_2_1:
        return "2:1";
      case AspectRatioType.RATIO_5_4:
        return "5:4";
      case AspectRatioType.RATIO_17_9:
        return "17:9";
      case AspectRatioType.RATIO_2_35_1:
        return "2.35:1";
      case AspectRatioType.MIX:
        return "mix";
    }
  }
}
