class Constants{
  static const String base = "https://b8fb-2405-201-e015-4026-75a2-2e1-6764-eb32.ngrok-free.app";

  static const String userAuth = '/api/user/auth';

  static const String login = '$base$userAuth/login';
  static const String register = '$base$userAuth/register';

  static const String user = '/api/user';
  static const String showNearbyLots = '$base$user/showNearbyLots';
  static const String rateLot = '$base$user/rateLot';
  static const String current = '$base$user/current';

  static const String getFreeSlot = '$base$user/getFreeSlot';
  static const String getPrice = '$base$user/getPrice';


}