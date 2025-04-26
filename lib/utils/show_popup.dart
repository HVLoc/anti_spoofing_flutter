// import 'package:app_settings/app_settings.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:easy_invoice_qlhd/assets.dart';
// import 'package:easy_invoice_qlhd/base/base.dart';
// import 'package:easy_invoice_qlhd/const/all_const.dart';
// import 'package:easy_invoice_qlhd/generated/locales.g.dart';
// import 'package:easy_invoice_qlhd/utils/utils.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:get/get.dart';
// import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// import '../application/app_controller.dart';
// import '../features/notification/notification.dart';

// part 'widgets/popup_widget.dart';

// class ShowPopup {
//   static int _numDialog = 0;

//   static Future<void> _showDialog(
//     Widget dialog,
//     bool isActiveBack, {
//     bool barrierDismissible = false,
//   }) async {
//     _numDialog++;
//     await Get.dialog(
//       PopScope(
//         canPop: false,
//         onPopInvoked: (didPop) {
//           if (didPop) {
//             return;
//           }
//           if (isActiveBack) {
//             Get.back();
//           }
//         },
//         child: dialog,
//       ),
//       barrierColor: AppColors.barrierColor,
//       barrierDismissible: barrierDismissible,
//     ).whenComplete(() => _numDialog--);
//   }

//   static Future<bool> onBackPress(bool isActiveBack) {
//     return Future.value(isActiveBack);
//   }

//   static void dismissDialog() {
//     if (_numDialog > 0) {
//       Get.back();
//     }
//   }

//   /// Hiển thị loading
//   ///
//   /// `isActiveBack` có cho phép back từ bàn phím Android khi loading hay không, default = true
//   void showLoadingWave({bool isActiveBack = true}) {
//     _showDialog(getLoadingWidget(), isActiveBack);
//   }

//   static Widget getLoadingWidget() {
//     return const Center(
//       child: CupertinoActivityIndicator(),
//     );
//   }

//   static Widget _baseButton(Function? function, String text,
//       {double? fontSize, Color? colorText, FontWeight? fontWeight}) {
//     return UtilWidgets.baseOnAction(
//         onTap: () {
//           dismissDialog();

//           function?.call();
//         },
//         child: TextButton(
//           onPressed: null,
//           style: ButtonStyle(
//             overlayColor: WidgetStateProperty.all(Colors.transparent),
//           ),
//           child: Text(
//             text,
//             style: AppTextStyle.font18Bo.copyWith(
//               fontSize: fontSize ?? AppDimens.fontBig(),
//               color: colorText ?? AppColors.textColor(),
//               fontWeight: fontWeight ?? FontWeight.normal,
//             ),
//             maxLines: 1,
//           ),
//         ));
//   }

//   /// Hiển thị dialog thông báo với nội dung cần hiển thị
//   ///
//   /// `funtion` hành động khi bấm đóng
//   ///
//   /// `isActiveBack` có cho phép back từ bàn phím Android hay không, default = true
//   ///
//   /// `isChangeContext` default true: khi gọi func không close dialog hiện tại (khi chuyển sang màn mới thì dialog hiện tại sẽ tự đóng)
//   static Future<void> showDialogNotification(
//     String content, {
//     bool isActiveBack = true,
//     Function? function,
//     String? nameAction,
//     String? subContent,
//   }) async {
//     await _showDialog(
//         Dialog(
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Container(
//                   padding: const EdgeInsets.only(top: 15, bottom: 10),
//                   child: Icon(
//                     _buildIconDialog(content),
//                     size: AppDimens.sizeDialogNotiIcon,
//                     color: Colors.blueAccent,
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(15.0),
//                   constraints: const BoxConstraints(maxHeight: 200),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           content,
//                           style: AppTextStyle.font16Bo,
//                           textAlign: TextAlign.center,
//                           overflow: TextOverflow.clip,
//                         ),
//                         if (subContent != null)
//                           Text(
//                             subContent,
//                             style: AppTextStyle.font16Bo,
//                             textAlign: TextAlign.center,
//                             overflow: TextOverflow.clip,
//                           ).paddingOnly(top: AppDimens.paddingVerySmall)
//                       ],
//                     ),
//                   ),
//                 ),
//                 const Divider(
//                   height: 1,
//                 ),
//                 Container(
//                   width: double.infinity,
//                   child: _baseButton(
//                     function,
//                     nameAction ?? LocaleKeys.app_close.tr,
//                     colorText: AppColors.colorBlueAccent,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         isActiveBack);
//   }

//   static void showDialogInputPhoneHSM({
//     bool isActiveBack = true,
//     Function(String)? function,
//     String? nameAction,
//   }) {
//     final TextEditingController _textEditingController =
//         TextEditingController();
//     final _formKey = GlobalKey<FormState>();
//     _showDialog(
//         Dialog(
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(AppDimens.defaultPadding,
//                     AppDimens.defaultPadding, AppDimens.defaultPadding, 0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                         LocaleKeys
//                             .searchInvoice_inputPhoneWhenNotHaveHSMHint.tr,
//                         textAlign: TextAlign.center,
//                         style: AppTextStyle.font16Bo
//                             .copyWith(color: AppColors.hintTextColor())),
//                     UtilWidgets.sizedBoxPadding,
//                     BuildInputText(InputTextModel(
//                         iconLeading: Icons.phone_forwarded,
//                         fillColor: AppColors.appBarColor(),
//                         textInputType: TextInputType.number,
//                         controller: _textEditingController,
//                         currentNode: FocusNode()..requestFocus(),
//                         validator: (value) {
//                           if (value!.isEmpty)
//                             return LocaleKeys.listInvoice_invoicePhoneEmpty.tr;
//                           if (value.length < 10 || value.length > 12)
//                             return LocaleKeys
//                                 .listInvoice_invoicePhoneInvalid.tr;
//                           return null;
//                         })
//                       ..isShowCounterText = false),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _baseButton(
//                             () {},
//                             LocaleKeys.app_cancel.tr,
//                             colorText: AppColors.hintTextColor(),
//                           ),
//                         ),
//                         Expanded(
//                           child: UtilWidgets.baseOnAction(
//                             onTap: () {
//                               if (_formKey.currentState!.validate()) {
//                                 dismissDialog();
//                                 function?.call(_textEditingController.text);
//                               }
//                             },
//                             child: TextButton(
//                               onPressed: null,
//                               style: ButtonStyle(
//                                 overlayColor:
//                                     WidgetStateProperty.all(Colors.transparent),
//                               ),
//                               child: Text(
//                                 nameAction ?? LocaleKeys.app_close.tr,
//                                 style: AppTextStyle.font18Bo.copyWith(
//                                   color: AppColors.colorBlueAccent,
//                                 ),
//                                 maxLines: 1,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ).paddingAll(AppDimens.defaultPadding),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         isActiveBack,
//         barrierDismissible: true);
//   }

//   static Future<void> showDialogInvoiceExtendInput(
//     int currentInvoiceNumber, {
//     bool isActiveBack = true,
//     Function(String, String)? function,
//     String? nameAction,
//   }) async {
//     final TextEditingController _inputNumberController =
//         TextEditingController();
//     final TextEditingController _inputPhoneController = TextEditingController();
//     final _formKey = GlobalKey<FormState>();
//     await _showDialog(
//         Dialog(
//           backgroundColor: AppColors.bottomSheetBgColor,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(AppDimens.defaultPadding,
//                   AppDimens.defaultPadding, AppDimens.defaultPadding, 0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Container(
//                       child: UtilWidgets.buildText(
//                         LocaleKeys.searchInvoice_invoiceExtendTitle.tr,
//                         style: AppTextStyle.font16Bo,
//                       ).paddingOnly(bottom: AppDimens.defaultPadding),
//                     ),
//                     Container(
//                       constraints: const BoxConstraints(maxHeight: 200),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: [
//                             UtilWidgets.buildText(
//                               LocaleKeys
//                                   .searchInvoice_hintInvoiceExtendCurrentNumber_1
//                                   .tr,
//                               style: AppTextStyle.font16Bo,
//                               textAlign: TextAlign.start,
//                               maxLine: 10,
//                             ),
//                             UtilWidgets.sizedBoxPadding,
//                             BuildInputText(InputTextModel(
//                               iconLeading: Icons.timeline,
//                               textInputType: TextInputType.number,
//                               controller: _inputNumberController,
//                               inputFormatters: 4,
//                               maxLengthInputForm: 20,
//                               hintText: LocaleKeys
//                                   .searchInvoice_invoiceNumberNeedToBuy.tr,
//                               currentNode: FocusNode()..requestFocus(),
//                               fillColor: AppColors.gray7,
//                               validator: (value) {
//                                 if (value!.isEmpty)
//                                   return LocaleKeys
//                                       .searchInvoice_invoiceNumberNeedToBuyError
//                                       .tr;
//                                 if (CurrencyUtils.formatNumberCurrency(value) <=
//                                     0)
//                                   return LocaleKeys
//                                       .searchInvoice_invoiceNumberNeedToBuyErrorZero
//                                       .tr;
//                                 return null;
//                               },
//                             )..isShowCounterText = false),
//                             UtilWidgets.sizedBoxPadding,
//                             BuildInputText(InputTextModel(
//                               iconLeading: Icons.phone_forwarded,
//                               textInputType: TextInputType.number,
//                               hintText: LocaleKeys.app_phoneContact.tr,
//                               inputFormatters: 3,
//                               maxLengthInputForm: 12,
//                               controller: _inputPhoneController,
//                               fillColor: AppColors.gray7,
//                               validator: (value) {
//                                 if (value!.isEmpty)
//                                   return LocaleKeys
//                                       .searchInvoice_invoicePhoneNumberNeedToBuyError
//                                       .tr;
//                                 return null;
//                               },
//                             )..isShowCounterText = false),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: _baseButton(
//                               () {},
//                               LocaleKeys.app_cancel.tr,
//                               colorText: AppColors.textColor(),
//                             ),
//                           ),
//                           Expanded(
//                             child: UtilWidgets.baseOnAction(
//                               onTap: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   dismissDialog();
//                                   function?.call(_inputNumberController.text,
//                                       _inputPhoneController.text);
//                                   Get.find<BaseGetxController>().showSnackBar(
//                                       LocaleKeys
//                                           .searchInvoice_invoiceExtendSuccess
//                                           .tr,
//                                       duration: const Duration(seconds: 5));
//                                 }
//                               },
//                               child: TextButton(
//                                 onPressed: null,
//                                 style: ButtonStyle(
//                                   overlayColor: WidgetStateProperty.all(
//                                       Colors.transparent),
//                                 ),
//                                 child: Text(
//                                   nameAction ?? LocaleKeys.app_close.tr,
//                                   style: AppTextStyle.font18Bo.copyWith(
//                                     color: AppColors.colorBlueAccent,
//                                   ),
//                                   maxLines: 1,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ).paddingAll(AppDimens.defaultPadding),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         isActiveBack);
//   }

//   static Future<void> showErrorMessage(String error, {String? errorFix}) async {
//     await showDialogNotification(
//       error,
//       subContent: errorFix,
//       isActiveBack: false,
//     );
//   }

//   static IconData _buildIconDialog(String errorStr) {
//     IconData iconData;
//     switch (errorStr) {
//       case AppStr.errorConnectTimeOut:
//         iconData = Icons.alarm_off;
//         break;
//       case AppStr.error400:
//       case AppStr.error401:
//       case AppStr.error404:
//       case AppStr.error502:
//       case AppStr.error503:
//       case AppStr.errorInternalServer:
//         iconData = Icons.warning;
//         break;
//       case AppStr.errorConnectFailedStr:
//         iconData = Icons.signal_wifi_off;
//         break;
//       default:
//         iconData = Icons.notifications_none;
//     }
//     return iconData;
//   }

//   static Future<void> showDialogConfirm(
//     String content, {
//     required Function confirm,
//     required String actionTitle,
//     bool isActiveBack = true,
//     String? title,
//     String? exitTitle,
//     Function? cancelFunc,
//     bool isAutoCloseDialog = false,
//   }) async {
//     await _showDialog(
//         Dialog(
//           backgroundColor: AppColors.backgroundPopUp,
//           insetPadding: const EdgeInsets.all(AppDimens.defaultPadding),
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppDimens.radius13),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(top: AppDimens.paddingMedium),
//                   child: AutoSizeText(
//                     title ?? LocaleKeys.app_notification.tr,
//                     textScaleFactor: 1,
//                     maxLines: 1,
//                     style: AppTextStyle.font14Semi.copyWith(
//                       color: AppColors.gray3,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.only(
//                       top: AppDimens.paddingSmall, bottom: AppDimens.padding25),
//                   constraints: const BoxConstraints(maxHeight: 200),
//                   child: SingleChildScrollView(
//                     child: Text(
//                       content,
//                       style: AppTextStyle.font16Bo.copyWith(
//                         color: AppColors.gray,
//                       ),
//                       textAlign: TextAlign.center,
//                       overflow: TextOverflow.clip,
//                     ).paddingSymmetric(horizontal: AppDimens.padding6),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     UtilWidgets.sizedBoxWidth20,
//                     Expanded(
//                       child: UtilWidgets.buildSolidButtonBack(
//                         title: exitTitle ?? LocaleKeys.app_cancel.tr,
//                         onPressed: () {
//                           dismissDialog();
//                           cancelFunc?.call();
//                         },
//                       ),
//                     ),
//                     UtilWidgets.sizedBoxWidth20,
//                     Expanded(
//                       child: UtilWidgets.buildSolidButton(
//                         title: actionTitle,
//                         onPressed: () {
//                           dismissDialog();
//                           confirm();
//                         },
//                       ),
//                     ),
//                     UtilWidgets.sizedBoxWidth20,
//                   ],
//                 ).paddingOnly(bottom: AppDimens.paddingMedium),
//               ],
//             ),
//           ),
//         ),
//         isActiveBack);
//   }

//   static void openAppSetting() {
//     showDialogConfirm(
//       LocaleKeys.pdf_pdfHelper.tr,
//       confirm: () {
//         Get.back();
//         AppSettings.openAppSettings();
//       },
//       actionTitle: LocaleKeys.app_openSettings.tr,
//     );
//   }

//   static void openSupport() {
//     showDialogSupport(
//       LocaleKeys.app_supportCus.tr,
//     );
//   }

//   static void showDialogSupport(
//     String content, {
//     bool isActiveBack = true,
//     Function? function,
//     String? nameAction,
//   }) {
//     _showDialog(
//         Dialog(
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(top: 15.0),
//                   child: UtilWidgets.buildText(
//                     content,
//                     maxLine: 1,
//                     style: AppTextStyle.font16Bo,
//                   ),
//                 ),
//                 UtilWidgets.sizedBox10,
//                 ItemUtils.itemLine(
//                   // iconColors: [AppColors.colorBlueB1FF,AppColors.colorBlueB1FF],
//                   title: LocaleKeys.app_zaloSupport.tr,
//                   imgAsset: Assets.ASSETS_ICONS_ZALO_ICON_PNG,
//                   func: () async {
//                     if (await canLaunchUrlString(AppConst.zalo)) {
//                       await launchUrlString(AppConst.zalo);
//                     }
//                   },
//                 ),
//                 UtilWidgets.sizedBox10,
//                 ItemUtils.itemLine(
//                   // iconColors: [AppColors.colorBlueB1FF,AppColors.colorBlueB1FF],
//                   title: LocaleKeys.login_loginFacebookSupport.tr,
//                   imgAsset: Assets.ASSETS_ICONS_FACEBOOK_ICON_PNG,
//                   func: () async {
//                     await launchUrlString(AppConst.facebook);
//                   },
//                 ),
//                 UtilWidgets.sizedBox10,
//                 ItemUtils.itemLine(
//                   title: LocaleKeys.account_phoneNumber.tr,
//                   imgAsset: Assets.ASSETS_ICONS_PHONE_ICON_PNG,
//                   func: () async {
//                     if (await canLaunchUrlString(AppConst.telSupportNumber)) {
//                       await launchUrlString(AppConst.telSupportNumber);
//                     }
//                   },
//                 ),
//                 Container(
//                   width: double.infinity,
//                   child: _baseButton(
//                     function,
//                     nameAction ?? LocaleKeys.app_close.tr,
//                     colorText: AppColors.colorBlueAccent,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         isActiveBack);
//   }

//   static void showDialogInputProfileCode({
//     bool isActiveBack = true,
//     Function(String)? confirmFuction,
//   }) {
//     final TextEditingController _inputProfileCodeController =
//         TextEditingController();
//     final _formKey = GlobalKey<FormState>();
//     _showDialog(
//         Dialog(
//           backgroundColor: AppColors.dialogInvExtend(),
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(AppDimens.defaultPadding,
//                   AppDimens.defaultPadding, AppDimens.defaultPadding, 0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Container(
//                       child: Text(
//                         LocaleKeys.invoiceDetail_invoiceProfileCodeDesc.tr,
//                         style: AppTextStyle.font16Bo,
//                       ).paddingOnly(bottom: AppDimens.defaultPadding),
//                     ),
//                     Container(
//                       constraints: const BoxConstraints(maxHeight: 200),
//                       child: SingleChildScrollView(
//                         child: BuildInputText(InputTextModel(
//                             iconLeading: Icons.format_align_left_sharp,
//                             textInputType: TextInputType.text,
//                             controller: _inputProfileCodeController,
//                             inputFormatters: 3,
//                             maxLengthInputForm: 20,
//                             hintText:
//                                 LocaleKeys.invoiceDetail_invoiceProfileCode.tr,
//                             currentNode: FocusNode()..requestFocus(),
//                             validator: (value) {
//                               if (value!.isEmpty)
//                                 return LocaleKeys
//                                     .searchInvoice_invoiceProfileCodeError.tr;

//                               return null;
//                             })
//                           ..isShowCounterText = false),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _baseButton(
//                             () {},
//                             LocaleKeys.app_cancel.tr,
//                             colorText: AppColors.textColor(),
//                           ),
//                         ),
//                         Expanded(
//                           child: UtilWidgets.baseOnAction(
//                             onTap: () {
//                               if (_formKey.currentState!.validate()) {
//                                 dismissDialog();
//                                 confirmFuction
//                                     ?.call(_inputProfileCodeController.text);
//                               }
//                             },
//                             child: TextButton(
//                               onPressed: null,
//                               style: ButtonStyle(
//                                 overlayColor:
//                                     WidgetStateProperty.all(Colors.transparent),
//                               ),
//                               child: Text(
//                                 LocaleKeys.app_accept.tr,
//                                 style: AppTextStyle.font16Bo.copyWith(
//                                   color: AppColors.colorBlueAccent,
//                                 ),
//                                 maxLines: 1,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ).paddingOnly(bottom: AppDimens.paddingVerySmall),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         isActiveBack);
//   }

//   static Future<void> showNotifyDialog({
//     required NotificationResult notification,
//   }) async {
//     final html = notification.contentMobile;
//     if (html == null || html.isEmpty) {
//       return;
//     }
//     await _showDialog(
//       _buildNotifyDialog(notification: notification),
//       false,
//       barrierDismissible: false,
//     );
//   }
// }
