
class Constant {
   static const String clientId = "aYjE5O3LGYJXCiC04hBTjmHSR8GSIu6zgHsff2pK";
   static const String clientSecret = "KHzMfMA8wyKGe4hsiRAPaJpDK0IDJAXoT0XqT8TbY7YMwTFeyWZyirZ9q85qxNIiGmATT8HjoseXgedwNYPwXiHtHGlKpTWpo2lywB3RqUcsVMQGTqCvNSsalxlRvcKa";

   static const int debitNumber = 10;
   // if LICENSE_ID is empty our system will choose a valid license from your emotiv account
   // if want to use a specific license. Please put your license here
   static const String licenseId = "c7a7b054-82d2-42fa-9b29-efb3c5eed053";
   // The name of the training profile used for the facial expression and mental command
   static const String trainingProfileName = "cortex-v2-example";

   // The name of a record
   static const String recordName = "record-cortex-v2-example";

   static const int getUserLoggedInRequestId = 1;
   static const int authorizeRequestId = 4;
   static const int getUserInfoRequestId = 5;
   static const int getLicenseInfoRequestId = 6;
   static const int queryHeadsetRequestId = 7;
   static const int controlDeviceRequestId = 8;
   static const int createSessionRequestId = 9;
   static const int updateSessionRequestId = 10;
   static const int createRecordRequestId = 11;
   static const int stopRecordRequestId = 12;
   static const int injectMarkerRequestId = 13;
   static const int subscribeDataRequestId = 14;
   static const int unsubscribeDataRequestId = 15;
   static const int createProfileRequestId = 16;
   static const int loadProfileRequestId = 17;
   static const int getCurrentProfileRequestId = 18;
   static const int trainingProfileMCRequestId = 19;
   static const int trainingProfileFERequestId = 20;
   static const int acceptTrainingProfileRequestId = 21;
   static const int saveTrainingProfileRequestId = 22;

   static const int loginRequestId = 23;
   static const int logoutRequestId = 24;

   static const int queryVirtualHeadsetRequestId = 25;
   static const int createVirtualHeadsetRequestId = 26;
   static const int updateVirtualHeadsetRequestId = 27;
   static const int deleteVirtualHeadsetRequestId = 28;
   static const int triggerVirtualHeadsetEventRequestId = 29;

   /* Warning code */
   static const int headsetIsConnected = 104;
   static const int headsetConnectionTimeout = 102;
}