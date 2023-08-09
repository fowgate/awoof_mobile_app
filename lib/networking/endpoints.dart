
/// Base url of the api endpoints
const BASE_URL = "https://backend.awoofapp.com/v1/";

/// Endpoints related to firebase token
const FCM_URL = BASE_URL + "firebase/get_token";

/// Endpoints related to authentication
const LOGIN_URL = BASE_URL + "auth";
const VERIFY_PIN_URL = BASE_URL + "auth/verify_pin";
const TWO_FA_URL = BASE_URL + "auth/verify_two_fa";
const TWO_FA_RESEND = BASE_URL + "auth/resend_two_fa";
const TWO_FA_RESEND_EMAIL = BASE_URL + "auth/resend_email_two_fa";

/// Endpoints related to users details and actions
const SIGN_UP_URL = BASE_URL + "users";
const EMAIL_CHECK_URL = BASE_URL + "users/email-check";
const USERNAME_CHECK_URL = BASE_URL + "users/username-check";
const PHONE_CHECK_URL = BASE_URL + "users/phone-check";
const SET_PIN_URL = BASE_URL + "users/oldpin";
const FORGET_PASSWORD_URL = BASE_URL + "users/forget-password";
const RESET_PASSWORD_URL = BASE_URL + "users/reset-password";
const RESET_PIN_URL = BASE_URL + "users/reset_pin";
const CHANGE_PIN_URL = BASE_URL + "users/pin";
const CHANGE_PASSWORD_URL = BASE_URL + "users/password";
const CHANGE_PICTURE_URL = BASE_URL + "users/changePicture";
const UPDATE_PROFILE_URL = BASE_URL + "users";
const FETCH_CURRENT_USER = BASE_URL + "users/me";
const DEDUCT_USER_BALANCE = BASE_URL + "users/deduct-balance";
const USER_NOTIFICATIONS = BASE_URL + "users/notifications";
const FETCH_ALL_CONTACTS = BASE_URL + "users/get_phone_numbers";
const SURPRISE_HISTORY = BASE_URL + "users/get_my_suprise";

/// Endpoints related to social account
const FETCH_MY_SOCIALS = BASE_URL + "socialAccount/me";
const ADD_MY_SOCIALS = BASE_URL + "socialAccount/add";
const UPDATE_MY_SOCIALS = BASE_URL + "socialAccount/update";

/// Endpoints related to accounts
const FETCH_USER_BANK_ACCOUNTS = BASE_URL + "accounts/me";
const VERIFY_USER_BANK_ACCOUNTS = BASE_URL + "accounts/verify";
const ADD_USER_BANK_ACCOUNTS = BASE_URL + "accounts";
const FETCH_USER_BANK = BASE_URL + "accounts";
const DELETE_USER_BANK_ACCOUNT = BASE_URL + "accounts";
const FETCH_ALL_NIGERIAN_BANKS = BASE_URL + "banks";

/// Endpoints to fetch and post giveaways
const GIVEAWAY_URL = BASE_URL + "giveaways";

/// More endpoints related to giveaway features
const GIVEAWAY_DETAILS_URL = BASE_URL + "giveaways/get/totalgiveawaydetails";
const FETCH_MY_GIVEAWAY_LIST = BASE_URL + "giveaways/me";
const CHECK_IF_PARTICIPATED = BASE_URL + "giveaways/checkParticipant";
const JOIN_GIVEAWAY = BASE_URL + "giveaways/join";
const MY_CONTESTS = BASE_URL + "giveaways/users/joined";
const MY_GIVEAWAY_PARTICIPANTS = BASE_URL + "admins/get_participants";
const GIVEAWAY_WINNERS_URL = BASE_URL + "giveaways/winners";
const TOP_AND_RECENT_WINNERS = BASE_URL + "giveaways/get/latestandtop";
const TOP_GIVERS = BASE_URL + "giveaways/get/topgivers";
const ALL_GIVERS = BASE_URL + "giveaways/get/top_givers_giveaways";
const MY_GIVEAWAY_WINNINGS = BASE_URL + "giveaways/get_my_wins";
const SEND_GIVEAWAY_PAY_MAIL = BASE_URL + "giveaways/send_mail";

const GIVEAWAY_CONDITIONS = BASE_URL + "giveaway-conditions";
const GIVEAWAY_TYPES = BASE_URL + "giveaway-types";

/// Endpoints related to airtime
const FETCH_MY_AIRTIME_TOPUP_HISTORY = BASE_URL + "airtime-topups/me";
const FETCH_TELCO_OPERATORS = BASE_URL + "airtime-topups/operators/countries";
const AIRTIME_TOPUP = BASE_URL + "airtime-topups";
const AIRTIME_ACCESS_TOKEN = BASE_URL + "airtime-topups/token";
const AUTODETECT_NUMBER = BASE_URL + "airtime-topups/operators/auto-detect";

/// Endpoints related to wallet top-ups
const WALLET_TOPUP = BASE_URL + "wallet-topups";
const FETCH_WALLET_TOPUP_HISTORY = BASE_URL + "wallet-topups/me";

/// Endpoints related to transfers
const FREE_WITHDRAWAL = BASE_URL + "transfers/free_withdrawal";
const FREE_WITHDRAWAL_HISTORY = BASE_URL + "transfers/my_free_withdrawals";
const FETCH_TRANSFER_HISTORY = BASE_URL + "transfers/me";
const INITIATE_TRANSFER = BASE_URL + "transfers/initiate";
const CREATE_TRANSFER = BASE_URL + "transfers/create";
const W2W_TRANSFER = BASE_URL + "transfers/w2w";

/// Endpoints for paystack initialize and verify payment
const INITIALIZE_PAYMENT = BASE_URL + 'transfers/initiate_payment';
const VERIFY_PAYMENT = BASE_URL + 'transfers/verify_payment';