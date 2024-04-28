class Constants{
  static const String base = "https://fae5-2405-201-e015-4026-fc46-1a01-d143-3019.ngrok-free.app";

  static const String userAuth = '/api/user/auth';

  static const String login = '$base$userAuth/login';
  static const String register = '$base$userAuth/register';

  static const String user = '/api/user';
  static const String showNearbyLots = '$base$user/showNearbyLots';
  static const String rateLot = '$base$user/rateLot';


}