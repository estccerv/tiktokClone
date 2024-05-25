class ConstRes {
  static final String base = 'https://nexus.involve-agency.com/';
  static const String apiKey = 'nexusdevkey';
  static final String baseUrl = '${base}api/';

  static final String itemBaseUrl = 'https://d17do51b1tbpdf.cloudfront.net/nexus/';

  // Agora Credential
  static final String customerId = 'b4d9dbb3fa44458eb265b0a4e5b075f3';
  static final String customerSecret = '62338c32a1b5460ca5ee6da6efaf8a11';

  // Starting screen open end_user_license_agreement sheet link
  static final String agreementUrl = "https://nexus.involve-agency.com/viewTerms";

  static final String bubblyCamera = 'bubbly_camera';
  static final bool isDialog = false;
}

const String appName = 'Nexus';
const companyName = 'Involve';
const defaultPlaceHolderText = 'S';
const byDefaultLanguage = 'es';

const int paginationLimit = 10;

// Live broadcast Video Quality : Resolution (Width×Height)
int liveWeight = 640;
int liveHeight = 480;
int liveFrameRate = 15; //Frame rate (fps）

// Image Quality
double maxHeight = 720;
double maxWidth = 720;
int imageQuality = 100;

//Strings
const List<String> paymentMethods = ['Paypal', 'Paytm', 'Other'];
const List<String> reportReasons = ['Sexual', 'Nudity', 'Religion', 'Other'];

// Video Moderation models  :- https://sightengine.com/docs/moderate-stored-video-asynchronously
String nudityModels = 'nudity,wad,gore';
