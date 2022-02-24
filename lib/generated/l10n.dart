// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Add`
  String get addButton {
    return Intl.message(
      'Add',
      name: 'addButton',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get doneButton {
    return Intl.message(
      'Done',
      name: 'doneButton',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get saveButton {
    return Intl.message(
      'Save',
      name: 'saveButton',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get confirmButton {
    return Intl.message(
      'Continue',
      name: 'confirmButton',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelButton {
    return Intl.message(
      'Cancel',
      name: 'cancelButton',
      desc: '',
      args: [],
    );
  }

  /// `year`
  String get hintTextYear {
    return Intl.message(
      'year',
      name: 'hintTextYear',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get hintTextDay {
    return Intl.message(
      'day',
      name: 'hintTextDay',
      desc: '',
      args: [],
    );
  }

  /// `month`
  String get hintTextMonth {
    return Intl.message(
      'month',
      name: 'hintTextMonth',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get profileAbout {
    return Intl.message(
      'About',
      name: 'profileAbout',
      desc: '',
      args: [],
    );
  }

  /// `Subscriptions`
  String get profileFollowing {
    return Intl.message(
      'Subscriptions',
      name: 'profileFollowing',
      desc: '',
      args: [],
    );
  }

  /// `Subscribers`
  String get profileFollowers {
    return Intl.message(
      'Subscribers',
      name: 'profileFollowers',
      desc: '',
      args: [],
    );
  }

  /// `Biography`
  String get biography {
    return Intl.message(
      'Biography',
      name: 'biography',
      desc: '',
      args: [],
    );
  }

  /// `Read more`
  String get readMore {
    return Intl.message(
      'Read more',
      name: 'readMore',
      desc: '',
      args: [],
    );
  }

  /// `Education Background`
  String get profileSkills {
    return Intl.message(
      'Education Background',
      name: 'profileSkills',
      desc: '',
      args: [],
    );
  }

  /// `Establishment`
  String get profileSkillsEstablishment {
    return Intl.message(
      'Establishment',
      name: 'profileSkillsEstablishment',
      desc: '',
      args: [],
    );
  }

  /// `University or Institute`
  String get profileSkillsEstablishmentHint {
    return Intl.message(
      'University or Institute',
      name: 'profileSkillsEstablishmentHint',
      desc: '',
      args: [],
    );
  }

  /// `Diploma`
  String get profileSkillsDiploma {
    return Intl.message(
      'Diploma',
      name: 'profileSkillsDiploma',
      desc: '',
      args: [],
    );
  }

  /// `Certificate or Diploma`
  String get profileSkillsDiplomaHint {
    return Intl.message(
      'Certificate or Diploma',
      name: 'profileSkillsDiplomaHint',
      desc: '',
      args: [],
    );
  }

  /// `Experiences`
  String get profileExperience {
    return Intl.message(
      'Experiences',
      name: 'profileExperience',
      desc: '',
      args: [],
    );
  }

  /// `The Company`
  String get profileExperienceCompany {
    return Intl.message(
      'The Company',
      name: 'profileExperienceCompany',
      desc: '',
      args: [],
    );
  }

  /// `Tv Station, Radio, Newspaper`
  String get profileExperienceCompanyHint {
    return Intl.message(
      'Tv Station, Radio, Newspaper',
      name: 'profileExperienceCompanyHint',
      desc: '',
      args: [],
    );
  }

  /// `Job Title`
  String get profileExperienceJobTitle {
    return Intl.message(
      'Job Title',
      name: 'profileExperienceJobTitle',
      desc: '',
      args: [],
    );
  }

  /// `Journalist, Editor, Reporter`
  String get profileExperienceJobTitleHint {
    return Intl.message(
      'Journalist, Editor, Reporter',
      name: 'profileExperienceJobTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Period`
  String get profileExperiencePeriode {
    return Intl.message(
      'Period',
      name: 'profileExperiencePeriode',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get profileExperiencePeriodeYear {
    return Intl.message(
      'Year',
      name: 'profileExperiencePeriodeYear',
      desc: '',
      args: [],
    );
  }

  /// `Enter company name`
  String get profileExperienceSnackBarCompanyName {
    return Intl.message(
      'Enter company name',
      name: 'profileExperienceSnackBarCompanyName',
      desc: '',
      args: [],
    );
  }

  /// `Enter job title`
  String get profileExperienceSnackBarJobTitle {
    return Intl.message(
      'Enter job title',
      name: 'profileExperienceSnackBarJobTitle',
      desc: '',
      args: [],
    );
  }

  /// `Invalid period`
  String get profileExperienceSnackBarInvalidPeriode {
    return Intl.message(
      'Invalid period',
      name: 'profileExperienceSnackBarInvalidPeriode',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to continue ?`
  String get deleteAsk {
    return Intl.message(
      'Do you want to continue ?',
      name: 'deleteAsk',
      desc: '',
      args: [],
    );
  }

  /// `Contacts`
  String get profileContacts {
    return Intl.message(
      'Contacts',
      name: 'profileContacts',
      desc: '',
      args: [],
    );
  }

  /// `Field required`
  String get requiredFiled {
    return Intl.message(
      'Field required',
      name: 'requiredFiled',
      desc: '',
      args: [],
    );
  }

  /// `Description of poll`
  String get descriptionPoll {
    return Intl.message(
      'Description of poll',
      name: 'descriptionPoll',
      desc: '',
      args: [],
    );
  }

  /// `Article references`
  String get articleReference {
    return Intl.message(
      'Article references',
      name: 'articleReference',
      desc: '',
      args: [],
    );
  }

  /// `Add one paragph a least`
  String get snackBarAddParagph {
    return Intl.message(
      'Add one paragph a least',
      name: 'snackBarAddParagph',
      desc: '',
      args: [],
    );
  }

  /// `Personality Profile`
  String get createProfiletitle {
    return Intl.message(
      'Personality Profile',
      name: 'createProfiletitle',
      desc: '',
      args: [],
    );
  }

  /// `Born`
  String get createProfileAgeHintText {
    return Intl.message(
      'Born',
      name: 'createProfileAgeHintText',
      desc: '',
      args: [],
    );
  }

  /// `Hometown`
  String get createProfileHomeTwonHintText {
    return Intl.message(
      'Hometown',
      name: 'createProfileHomeTwonHintText',
      desc: '',
      args: [],
    );
  }

  /// `Current City`
  String get createProfilecurrentCityHintText {
    return Intl.message(
      'Current City',
      name: 'createProfilecurrentCityHintText',
      desc: '',
      args: [],
    );
  }

  /// `Curriculum Vitae`
  String get createProfileCvHintText {
    return Intl.message(
      'Curriculum Vitae',
      name: 'createProfileCvHintText',
      desc: '',
      args: [],
    );
  }

  /// `Nationality`
  String get createProfileNationality {
    return Intl.message(
      'Nationality',
      name: 'createProfileNationality',
      desc: '',
      args: [],
    );
  }

  /// `Children`
  String get createProfileChildren {
    return Intl.message(
      'Children',
      name: 'createProfileChildren',
      desc: '',
      args: [],
    );
  }

  /// `Relationship Status`
  String get createProfileRelation {
    return Intl.message(
      'Relationship Status',
      name: 'createProfileRelation',
      desc: '',
      args: [],
    );
  }

  /// `Education`
  String get createProfileEducation {
    return Intl.message(
      'Education',
      name: 'createProfileEducation',
      desc: '',
      args: [],
    );
  }

  /// `Occupation`
  String get createProfileOccupation {
    return Intl.message(
      'Occupation',
      name: 'createProfileOccupation',
      desc: '',
      args: [],
    );
  }

  /// `Add at least one step`
  String get snackBarAddSteps {
    return Intl.message(
      'Add at least one step',
      name: 'snackBarAddSteps',
      desc: '',
      args: [],
    );
  }

  /// `True`
  String get trueKey {
    return Intl.message(
      'True',
      name: 'trueKey',
      desc: '',
      args: [],
    );
  }

  /// `False`
  String get falseKey {
    return Intl.message(
      'False',
      name: 'falseKey',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report {
    return Intl.message(
      'Report',
      name: 'report',
      desc: '',
      args: [],
    );
  }

  /// `Dislike`
  String get dislike {
    return Intl.message(
      'Dislike',
      name: 'dislike',
      desc: '',
      args: [],
    );
  }

  /// `The five most read`
  String get fiveMostRead {
    return Intl.message(
      'The five most read',
      name: 'fiveMostRead',
      desc: '',
      args: [],
    );
  }

  /// `The five most view`
  String get fiveMostViews {
    return Intl.message(
      'The five most view',
      name: 'fiveMostViews',
      desc: '',
      args: [],
    );
  }

  /// `Deleted publication`
  String get deletedPost {
    return Intl.message(
      'Deleted publication',
      name: 'deletedPost',
      desc: '',
      args: [],
    );
  }

  /// `No publication has been deleted yet`
  String get noPostDeletedYet {
    return Intl.message(
      'No publication has been deleted yet',
      name: 'noPostDeletedYet',
      desc: '',
      args: [],
    );
  }

  /// `Likes`
  String get like {
    return Intl.message(
      'Likes',
      name: 'like',
      desc: '',
      args: [],
    );
  }

  /// `Written by `
  String get postViewWrittenBy {
    return Intl.message(
      'Written by ',
      name: 'postViewWrittenBy',
      desc: '',
      args: [],
    );
  }

  /// `Updated`
  String get postViewUpdate {
    return Intl.message(
      'Updated',
      name: 'postViewUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Picture by `
  String get pictureBy {
    return Intl.message(
      'Picture by ',
      name: 'pictureBy',
      desc: '',
      args: [],
    );
  }

  /// `Video by `
  String get videoBy {
    return Intl.message(
      'Video by ',
      name: 'videoBy',
      desc: '',
      args: [],
    );
  }

  /// `Views`
  String get views {
    return Intl.message(
      'Views',
      name: 'views',
      desc: '',
      args: [],
    );
  }

  /// `Type your reply`
  String get pictureDetailsAddComment {
    return Intl.message(
      'Type your reply',
      name: 'pictureDetailsAddComment',
      desc: '',
      args: [],
    );
  }

  /// `Modify`
  String get commentModifer {
    return Intl.message(
      'Modify',
      name: 'commentModifer',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get commentDelete {
    return Intl.message(
      'Delete',
      name: 'commentDelete',
      desc: '',
      args: [],
    );
  }

  /// `Replies`
  String get commentReply {
    return Intl.message(
      'Replies',
      name: 'commentReply',
      desc: '',
      args: [],
    );
  }

  /// `Invite`
  String get inviteButton {
    return Intl.message(
      'Invite',
      name: 'inviteButton',
      desc: '',
      args: [],
    );
  }

  /// `I like`
  String get iLikeButton {
    return Intl.message(
      'I like',
      name: 'iLikeButton',
      desc: '',
      args: [],
    );
  }

  /// `Full-Screen`
  String get fullScreen {
    return Intl.message(
      'Full-Screen',
      name: 'fullScreen',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get message {
    return Intl.message(
      'Messages',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notificationTitle {
    return Intl.message(
      'Notifications',
      name: 'notificationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message(
      'About Us',
      name: 'aboutUs',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Cookie Policy`
  String get cookiePolicy {
    return Intl.message(
      'Cookie Policy',
      name: 'cookiePolicy',
      desc: '',
      args: [],
    );
  }

  /// `Copyright Policy`
  String get copyrightPolicy {
    return Intl.message(
      'Copyright Policy',
      name: 'copyrightPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms`
  String get terms {
    return Intl.message(
      'Terms',
      name: 'terms',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Setting and Privacy`
  String get accountMenuProfileSetting {
    return Intl.message(
      'Setting and Privacy',
      name: 'accountMenuProfileSetting',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get accountMenuLogOut {
    return Intl.message(
      'Log Out',
      name: 'accountMenuLogOut',
      desc: '',
      args: [],
    );
  }

  /// `See your profile`
  String get seeYourProfile {
    return Intl.message(
      'See your profile',
      name: 'seeYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get helpAndSupport {
    return Intl.message(
      'Help & Support',
      name: 'helpAndSupport',
      desc: '',
      args: [],
    );
  }

  /// `Account email`
  String get accountEmail {
    return Intl.message(
      'Account email',
      name: 'accountEmail',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get changePassword {
    return Intl.message(
      'Change password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `New email`
  String get newEmail {
    return Intl.message(
      'New email',
      name: 'newEmail',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get currentPassword {
    return Intl.message(
      'Current password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Adding a current email to your Teltrue account can help you log in and receive notifications as well as reset your password easily.`
  String get newEmailDescription {
    return Intl.message(
      'Adding a current email to your Teltrue account can help you log in and receive notifications as well as reset your password easily.',
      name: 'newEmailDescription',
      desc: '',
      args: [],
    );
  }

  /// `Current password is wrong`
  String get currentPassIsWrong {
    return Intl.message(
      'Current password is wrong',
      name: 'currentPassIsWrong',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters`
  String get passWordCondition {
    return Intl.message(
      'Password must be at least 8 characters',
      name: 'passWordCondition',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, you cannot send a message to this account`
  String get messageSorryCannotSend {
    return Intl.message(
      'Sorry, you cannot send a message to this account',
      name: 'messageSorryCannotSend',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get blockButton {
    return Intl.message(
      'Block',
      name: 'blockButton',
      desc: '',
      args: [],
    );
  }

  /// `Unblock`
  String get suggestionChatUnBlock {
    return Intl.message(
      'Unblock',
      name: 'suggestionChatUnBlock',
      desc: '',
      args: [],
    );
  }

  /// `Type your message`
  String get suggestionChatTypeMsg {
    return Intl.message(
      'Type your message',
      name: 'suggestionChatTypeMsg',
      desc: '',
      args: [],
    );
  }

  /// `Delete Chat`
  String get suggestionChatDeleteConversation {
    return Intl.message(
      'Delete Chat',
      name: 'suggestionChatDeleteConversation',
      desc: '',
      args: [],
    );
  }

  /// `Block messages and calls ?`
  String get suggestionChatBlockMsgRequest {
    return Intl.message(
      'Block messages and calls ?',
      name: 'suggestionChatBlockMsgRequest',
      desc: '',
      args: [],
    );
  }

  /// `Telltrue Account`
  String get suggestionChatBlocktitle2 {
    return Intl.message(
      'Telltrue Account',
      name: 'suggestionChatBlocktitle2',
      desc: '',
      args: [],
    );
  }

  /// `You can't message or call them in this chat, and you won't receive their messages or calls.`
  String get suggestionChatBlockDescrip {
    return Intl.message(
      'You can\'t message or call them in this chat, and you won\'t receive their messages or calls.',
      name: 'suggestionChatBlockDescrip',
      desc: '',
      args: [],
    );
  }

  /// `You Blocked Messages and Calls From`
  String get suggestionChatBlocktitle1 {
    return Intl.message(
      'You Blocked Messages and Calls From',
      name: 'suggestionChatBlocktitle1',
      desc: '',
      args: [],
    );
  }

  /// `Your won't receive messages or calls  from `
  String get suggestionChatBlockMsgDescrip1 {
    return Intl.message(
      'Your won\'t receive messages or calls  from ',
      name: 'suggestionChatBlockMsgDescrip1',
      desc: '',
      args: [],
    );
  }

  /// `\nThe conversation will stay in Chats unless you hide it.`
  String get suggestionChatBlockMsgDescrip2 {
    return Intl.message(
      '\nThe conversation will stay in Chats unless you hide it.',
      name: 'suggestionChatBlockMsgDescrip2',
      desc: '',
      args: [],
    );
  }

  /// `Once you delete your copy of this conversation, it cannot be undone.`
  String get suggestionChatDeleteConversationDescrip {
    return Intl.message(
      'Once you delete your copy of this conversation, it cannot be undone.',
      name: 'suggestionChatDeleteConversationDescrip',
      desc: '',
      args: [],
    );
  }

  /// `You didn't make any conversation yet`
  String get messageNoMessageYet {
    return Intl.message(
      'You didn\'t make any conversation yet',
      name: 'messageNoMessageYet',
      desc: '',
      args: [],
    );
  }

  /// `Start a new conversation`
  String get messageStartMessage {
    return Intl.message(
      'Start a new conversation',
      name: 'messageStartMessage',
      desc: '',
      args: [],
    );
  }

  /// `©2021 Telltrue Company. All rights reserved.`
  String get copyRight {
    return Intl.message(
      '©2021 Telltrue Company. All rights reserved.',
      name: 'copyRight',
      desc: '',
      args: [],
    );
  }

  /// `Your profile photo helps your team know who you are in Telltrue. And if your photo is clear, it'll be easier for someone to pick you out in a crowd or a meeting!`
  String get addprofileImageDes {
    return Intl.message(
      'Your profile photo helps your team know who you are in Telltrue. And if your photo is clear, it\'ll be easier for someone to pick you out in a crowd or a meeting!',
      name: 'addprofileImageDes',
      desc: '',
      args: [],
    );
  }

  /// `Success !`
  String get subtitleReviewPage {
    return Intl.message(
      'Success !',
      name: 'subtitleReviewPage',
      desc: '',
      args: [],
    );
  }

  /// `Thank's `
  String get descriptionP1ReviewPage {
    return Intl.message(
      'Thank\'s ',
      name: 'descriptionP1ReviewPage',
      desc: '',
      args: [],
    );
  }

  /// `, We've received your request for a Journalist account and we are in the process of reviewing it (24hr). Take in mind that Your ID will be securely stored and deleted within 30 days of confirming your identity`
  String get descriptionP3ReviewPage {
    return Intl.message(
      ', We\'ve received your request for a Journalist account and we are in the process of reviewing it (24hr). Take in mind that Your ID will be securely stored and deleted within 30 days of confirming your identity',
      name: 'descriptionP3ReviewPage',
      desc: '',
      args: [],
    );
  }

  /// `Personal pictures`
  String get personalPicture {
    return Intl.message(
      'Personal pictures',
      name: 'personalPicture',
      desc: '',
      args: [],
    );
  }

  /// `Post pictures`
  String get postPicture {
    return Intl.message(
      'Post pictures',
      name: 'postPicture',
      desc: '',
      args: [],
    );
  }

  /// `No Pictures to show`
  String get noPictureToshow {
    return Intl.message(
      'No Pictures to show',
      name: 'noPictureToshow',
      desc: '',
      args: [],
    );
  }

  /// `Set as profile picture`
  String get pictureSetAsProfilePic {
    return Intl.message(
      'Set as profile picture',
      name: 'pictureSetAsProfilePic',
      desc: '',
      args: [],
    );
  }

  /// `Delete this Photo`
  String get pictureDelete {
    return Intl.message(
      'Delete this Photo',
      name: 'pictureDelete',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this photo ?`
  String get pictureDeleteRequest {
    return Intl.message(
      'Are you sure you want to delete this photo ?',
      name: 'pictureDeleteRequest',
      desc: '',
      args: [],
    );
  }

  /// `Pictures`
  String get profilePicAndVid {
    return Intl.message(
      'Pictures',
      name: 'profilePicAndVid',
      desc: '',
      args: [],
    );
  }

  /// `Pictures of you`
  String get profilePicturesOfYou {
    return Intl.message(
      'Pictures of you',
      name: 'profilePicturesOfYou',
      desc: '',
      args: [],
    );
  }

  /// `Videos`
  String get profileVideo {
    return Intl.message(
      'Videos',
      name: 'profileVideo',
      desc: '',
      args: [],
    );
  }

  /// `Your Videos`
  String get yourVideos {
    return Intl.message(
      'Your Videos',
      name: 'yourVideos',
      desc: '',
      args: [],
    );
  }

  /// `Live videos`
  String get liveVideos {
    return Intl.message(
      'Live videos',
      name: 'liveVideos',
      desc: '',
      args: [],
    );
  }

  /// `Readers`
  String get readers {
    return Intl.message(
      'Readers',
      name: 'readers',
      desc: '',
      args: [],
    );
  }

  /// `No breaking news yet`
  String get nobreakingNewsyet {
    return Intl.message(
      'No breaking news yet',
      name: 'nobreakingNewsyet',
      desc: '',
      args: [],
    );
  }

  /// `When you get breaking news, they'll show up here`
  String get noBreakingNewsDes {
    return Intl.message(
      'When you get breaking news, they\'ll show up here',
      name: 'noBreakingNewsDes',
      desc: '',
      args: [],
    );
  }

  /// `This breaking news is unfortunately not available.`
  String get breakingNewsisAvailable {
    return Intl.message(
      'This breaking news is unfortunately not available.',
      name: 'breakingNewsisAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No replies here yet...`
  String get noCommentYetTitle {
    return Intl.message(
      'No replies here yet...',
      name: 'noCommentYetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Be the first to share what you think !`
  String get noCommentsYetDes {
    return Intl.message(
      'Be the first to share what you think !',
      name: 'noCommentsYetDes',
      desc: '',
      args: [],
    );
  }

  /// `Read less`
  String get readLess {
    return Intl.message(
      'Read less',
      name: 'readLess',
      desc: '',
      args: [],
    );
  }

  /// `vote`
  String get vote {
    return Intl.message(
      'vote',
      name: 'vote',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get undo {
    return Intl.message(
      'Undo',
      name: 'undo',
      desc: '',
      args: [],
    );
  }

  /// `Please select a the problem to continue`
  String get reportSelectProb {
    return Intl.message(
      'Please select a the problem to continue',
      name: 'reportSelectProb',
      desc: '',
      args: [],
    );
  }

  /// `Unethical content `
  String get report1 {
    return Intl.message(
      'Unethical content ',
      name: 'report1',
      desc: '',
      args: [],
    );
  }

  /// `Trivial content`
  String get report2 {
    return Intl.message(
      'Trivial content',
      name: 'report2',
      desc: '',
      args: [],
    );
  }

  /// `Content that harms religion`
  String get report3 {
    return Intl.message(
      'Content that harms religion',
      name: 'report3',
      desc: '',
      args: [],
    );
  }

  /// `Content that harms security and incites violence`
  String get report4 {
    return Intl.message(
      'Content that harms security and incites violence',
      name: 'report4',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get sendButton {
    return Intl.message(
      'Send',
      name: 'sendButton',
      desc: '',
      args: [],
    );
  }

  /// `Interested`
  String get eventInterestedButton {
    return Intl.message(
      'Interested',
      name: 'eventInterestedButton',
      desc: '',
      args: [],
    );
  }

  /// `Not Interested`
  String get eventNotInterestedButton {
    return Intl.message(
      'Not Interested',
      name: 'eventNotInterestedButton',
      desc: '',
      args: [],
    );
  }

  /// `Research article`
  String get addPostArticle {
    return Intl.message(
      'Research article',
      name: 'addPostArticle',
      desc: '',
      args: [],
    );
  }

  /// `General title`
  String get addPostArticleGeneralTitle {
    return Intl.message(
      'General title',
      name: 'addPostArticleGeneralTitle',
      desc: '',
      args: [],
    );
  }

  /// `Writers`
  String get addPostArticleWrittersHintText {
    return Intl.message(
      'Writers',
      name: 'addPostArticleWrittersHintText',
      desc: '',
      args: [],
    );
  }

  /// `Keywords`
  String get addPostArticleKeywords {
    return Intl.message(
      'Keywords',
      name: 'addPostArticleKeywords',
      desc: '',
      args: [],
    );
  }

  /// `Correspondence`
  String get addPostArticleCoresspondence {
    return Intl.message(
      'Correspondence',
      name: 'addPostArticleCoresspondence',
      desc: '',
      args: [],
    );
  }

  /// `Write Abstract here`
  String get addPostArticleAbstract {
    return Intl.message(
      'Write Abstract here',
      name: 'addPostArticleAbstract',
      desc: '',
      args: [],
    );
  }

  /// `Conclusion`
  String get addPostArticleConclusion {
    return Intl.message(
      'Conclusion',
      name: 'addPostArticleConclusion',
      desc: '',
      args: [],
    );
  }

  /// `Introduction`
  String get addPostArticleIntro {
    return Intl.message(
      'Introduction',
      name: 'addPostArticleIntro',
      desc: '',
      args: [],
    );
  }

  /// `Participants`
  String get participants {
    return Intl.message(
      'Participants',
      name: 'participants',
      desc: '',
      args: [],
    );
  }

  /// `Career`
  String get career {
    return Intl.message(
      'Career',
      name: 'career',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get closeButton {
    return Intl.message(
      'Close',
      name: 'closeButton',
      desc: '',
      args: [],
    );
  }

  /// `Abstract`
  String get abstrack {
    return Intl.message(
      'Abstract',
      name: 'abstrack',
      desc: '',
      args: [],
    );
  }

  /// `Reference`
  String get reference {
    return Intl.message(
      'Reference',
      name: 'reference',
      desc: '',
      args: [],
    );
  }

  /// `No Videos to show`
  String get noVideoShow {
    return Intl.message(
      'No Videos to show',
      name: 'noVideoShow',
      desc: '',
      args: [],
    );
  }

  /// `No Live Video to show`
  String get noLiveVideoShow {
    return Intl.message(
      'No Live Video to show',
      name: 'noLiveVideoShow',
      desc: '',
      args: [],
    );
  }

  /// `No matching publications found`
  String get noPubmatching {
    return Intl.message(
      'No matching publications found',
      name: 'noPubmatching',
      desc: '',
      args: [],
    );
  }

  /// `No matching event found`
  String get noEventmatching {
    return Intl.message(
      'No matching event found',
      name: 'noEventmatching',
      desc: '',
      args: [],
    );
  }

  /// ` No matching telltrue user found`
  String get noTelltruefound {
    return Intl.message(
      ' No matching telltrue user found',
      name: 'noTelltruefound',
      desc: '',
      args: [],
    );
  }

  /// `results`
  String get result {
    return Intl.message(
      'results',
      name: 'result',
      desc: '',
      args: [],
    );
  }

  /// `See all publications result`
  String get seeAllpub {
    return Intl.message(
      'See all publications result',
      name: 'seeAllpub',
      desc: '',
      args: [],
    );
  }

  /// `See all events result`
  String get seeAllEvent {
    return Intl.message(
      'See all events result',
      name: 'seeAllEvent',
      desc: '',
      args: [],
    );
  }

  /// `Telltrue users`
  String get telltrueUser {
    return Intl.message(
      'Telltrue users',
      name: 'telltrueUser',
      desc: '',
      args: [],
    );
  }

  /// `Famous person identified`
  String get famousPersonIdentified {
    return Intl.message(
      'Famous person identified',
      name: 'famousPersonIdentified',
      desc: '',
      args: [],
    );
  }

  /// `Event identified`
  String get eventIdentified {
    return Intl.message(
      'Event identified',
      name: 'eventIdentified',
      desc: '',
      args: [],
    );
  }

  /// `Place identified`
  String get placeIdentified {
    return Intl.message(
      'Place identified',
      name: 'placeIdentified',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Added by`
  String get addBy {
    return Intl.message(
      'Added by',
      name: 'addBy',
      desc: '',
      args: [],
    );
  }

  /// `See all people result`
  String get seeAllpeople {
    return Intl.message(
      'See all people result',
      name: 'seeAllpeople',
      desc: '',
      args: [],
    );
  }

  /// `Search Telltrue`
  String get searchTelltrue {
    return Intl.message(
      'Search Telltrue',
      name: 'searchTelltrue',
      desc: '',
      args: [],
    );
  }

  /// `Search for `
  String get searchFor {
    return Intl.message(
      'Search for ',
      name: 'searchFor',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribe`
  String get profileUnfolowButton {
    return Intl.message(
      'Unsubscribe',
      name: 'profileUnfolowButton',
      desc: '',
      args: [],
    );
  }

  /// `Suggestions for you`
  String get suggestionsForyou {
    return Intl.message(
      'Suggestions for you',
      name: 'suggestionsForyou',
      desc: '',
      args: [],
    );
  }

  /// `Today’s top writing`
  String get todayTopWritting {
    return Intl.message(
      'Today’s top writing',
      name: 'todayTopWritting',
      desc: '',
      args: [],
    );
  }

  /// `No notifications yet`
  String get notificationNoYetTitle {
    return Intl.message(
      'No notifications yet',
      name: 'notificationNoYetTitle',
      desc: '',
      args: [],
    );
  }

  /// `When you get notifications, they'll show up here`
  String get notificationNoYetDes {
    return Intl.message(
      'When you get notifications, they\'ll show up here',
      name: 'notificationNoYetDes',
      desc: '',
      args: [],
    );
  }

  /// `  invite you to read `
  String get inviteYouToReadAn {
    return Intl.message(
      '  invite you to read ',
      name: 'inviteYouToReadAn',
      desc: '',
      args: [],
    );
  }

  /// `  invite you to answer `
  String get inviteYouToAnswer {
    return Intl.message(
      '  invite you to answer ',
      name: 'inviteYouToAnswer',
      desc: '',
      args: [],
    );
  }

  /// `  invite you to watch `
  String get inviteYouToWatch {
    return Intl.message(
      '  invite you to watch ',
      name: 'inviteYouToWatch',
      desc: '',
      args: [],
    );
  }

  /// `  invite you to see `
  String get inviteYouToSee {
    return Intl.message(
      '  invite you to see ',
      name: 'inviteYouToSee',
      desc: '',
      args: [],
    );
  }

  /// `  invite you to see an event `
  String get inviteYouToReadEvent {
    return Intl.message(
      '  invite you to see an event ',
      name: 'inviteYouToReadEvent',
      desc: '',
      args: [],
    );
  }

  /// `  started following you.`
  String get notificationSubscribe {
    return Intl.message(
      '  started following you.',
      name: 'notificationSubscribe',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get and {
    return Intl.message(
      'and',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `other`
  String get other {
    return Intl.message(
      'other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// ` commented your `
  String get commentedYour {
    return Intl.message(
      ' commented your ',
      name: 'commentedYour',
      desc: '',
      args: [],
    );
  }

  /// `  reacted to your `
  String get likedYour {
    return Intl.message(
      '  reacted to your ',
      name: 'likedYour',
      desc: '',
      args: [],
    );
  }

  /// `  answered your poll`
  String get answerYour {
    return Intl.message(
      '  answered your poll',
      name: 'answerYour',
      desc: '',
      args: [],
    );
  }

  /// ` report your `
  String get reportYour {
    return Intl.message(
      ' report your ',
      name: 'reportYour',
      desc: '',
      args: [],
    );
  }

  /// `This publication is maybe fake.\n So, it will be deleted from Telltrue`
  String get deletePostDescription {
    return Intl.message(
      'This publication is maybe fake.\n So, it will be deleted from Telltrue',
      name: 'deletePostDescription',
      desc: '',
      args: [],
    );
  }

  /// `Unfortunately, we will delete your `
  String get notiDeletePost {
    return Intl.message(
      'Unfortunately, we will delete your ',
      name: 'notiDeletePost',
      desc: '',
      args: [],
    );
  }

  /// `Enter your full name as it is written on your passport or national identity card.`
  String get fullNamerequired {
    return Intl.message(
      'Enter your full name as it is written on your passport or national identity card.',
      name: 'fullNamerequired',
      desc: '',
      args: [],
    );
  }

  /// `Choose a file`
  String get chooseFile {
    return Intl.message(
      'Choose a file',
      name: 'chooseFile',
      desc: '',
      args: [],
    );
  }

  /// `Driver's license`
  String get driversLicence {
    return Intl.message(
      'Driver\'s license',
      name: 'driversLicence',
      desc: '',
      args: [],
    );
  }

  /// `Upload a photo or scan of your driver's licence.`
  String get driverLicenceDes {
    return Intl.message(
      'Upload a photo or scan of your driver\'s licence.',
      name: 'driverLicenceDes',
      desc: '',
      args: [],
    );
  }

  /// `Front side of your driver's licence`
  String get driverLicenceFrontSideTitle {
    return Intl.message(
      'Front side of your driver\'s licence',
      name: 'driverLicenceFrontSideTitle',
      desc: '',
      args: [],
    );
  }

  /// `Upload the front side of your driver's licence`
  String get driverLicenceFrontSideDes {
    return Intl.message(
      'Upload the front side of your driver\'s licence',
      name: 'driverLicenceFrontSideDes',
      desc: '',
      args: [],
    );
  }

  /// `National ID`
  String get nationalId {
    return Intl.message(
      'National ID',
      name: 'nationalId',
      desc: '',
      args: [],
    );
  }

  /// `Upload a photo or scan of your document.`
  String get nationalIdDes {
    return Intl.message(
      'Upload a photo or scan of your document.',
      name: 'nationalIdDes',
      desc: '',
      args: [],
    );
  }

  /// `Front side of your document`
  String get nationalIdFrontSideTitle {
    return Intl.message(
      'Front side of your document',
      name: 'nationalIdFrontSideTitle',
      desc: '',
      args: [],
    );
  }

  /// `Upload the front side of your document`
  String get nationalIdFrontSideDes {
    return Intl.message(
      'Upload the front side of your document',
      name: 'nationalIdFrontSideDes',
      desc: '',
      args: [],
    );
  }

  /// `Back side of your document`
  String get nationalIdBackSideTitle {
    return Intl.message(
      'Back side of your document',
      name: 'nationalIdBackSideTitle',
      desc: '',
      args: [],
    );
  }

  /// `Upload the back side of your document`
  String get nationalIdBackSideDes {
    return Intl.message(
      'Upload the back side of your document',
      name: 'nationalIdBackSideDes',
      desc: '',
      args: [],
    );
  }

  /// `Passport`
  String get passport {
    return Intl.message(
      'Passport',
      name: 'passport',
      desc: '',
      args: [],
    );
  }

  /// `Upload a photo or scan of your passport photo page.`
  String get passportDes {
    return Intl.message(
      'Upload a photo or scan of your passport photo page.',
      name: 'passportDes',
      desc: '',
      args: [],
    );
  }

  /// `Details page with the picture`
  String get passportUploadDes {
    return Intl.message(
      'Details page with the picture',
      name: 'passportUploadDes',
      desc: '',
      args: [],
    );
  }

  /// `Choose a different ID document`
  String get chooseOtherOption {
    return Intl.message(
      'Choose a different ID document',
      name: 'chooseOtherOption',
      desc: '',
      args: [],
    );
  }

  /// `Back side of your driver's licence`
  String get driverLicenceBackSideTitle {
    return Intl.message(
      'Back side of your driver\'s licence',
      name: 'driverLicenceBackSideTitle',
      desc: '',
      args: [],
    );
  }

  /// `Upload the back side of your driver's licence`
  String get driverLicenceBackideDes {
    return Intl.message(
      'Upload the back side of your driver\'s licence',
      name: 'driverLicenceBackideDes',
      desc: '',
      args: [],
    );
  }

  /// `Upload a proof of your identity`
  String get uploadAproofOfidendity {
    return Intl.message(
      'Upload a proof of your identity',
      name: 'uploadAproofOfidendity',
      desc: '',
      args: [],
    );
  }

  /// `Please choose the country that issued the ID document you have on hand.`
  String get chooseCountryDes {
    return Intl.message(
      'Please choose the country that issued the ID document you have on hand.',
      name: 'chooseCountryDes',
      desc: '',
      args: [],
    );
  }

  /// `ID issuing country`
  String get countryDropDowntitle {
    return Intl.message(
      'ID issuing country',
      name: 'countryDropDowntitle',
      desc: '',
      args: [],
    );
  }

  /// `Select Country...`
  String get selectCountry {
    return Intl.message(
      'Select Country...',
      name: 'selectCountry',
      desc: '',
      args: [],
    );
  }

  /// `Document type`
  String get documentType {
    return Intl.message(
      'Document type',
      name: 'documentType',
      desc: '',
      args: [],
    );
  }

  /// `Select a document type`
  String get selectDocType {
    return Intl.message(
      'Select a document type',
      name: 'selectDocType',
      desc: '',
      args: [],
    );
  }

  /// `Full legal first and last names`
  String get firstAndlastName {
    return Intl.message(
      'Full legal first and last names',
      name: 'firstAndlastName',
      desc: '',
      args: [],
    );
  }

  /// `Full legal first and middle names`
  String get firstAndMiddleName {
    return Intl.message(
      'Full legal first and middle names',
      name: 'firstAndMiddleName',
      desc: '',
      args: [],
    );
  }

  /// `Spell your name exactly as it's shown on your passport or ID card.`
  String get spellYourName {
    return Intl.message(
      'Spell your name exactly as it\'s shown on your passport or ID card.',
      name: 'spellYourName',
      desc: '',
      args: [],
    );
  }

  /// `Full legal last name(s)`
  String get fullLegalLastName {
    return Intl.message(
      'Full legal last name(s)',
      name: 'fullLegalLastName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your hometwon as it is written on your passport or national identity card.`
  String get spellHomeTwon {
    return Intl.message(
      'Enter your hometwon as it is written on your passport or national identity card.',
      name: 'spellHomeTwon',
      desc: '',
      args: [],
    );
  }

  /// `Enter your current location as it is written on your passport or national identity card.`
  String get spellCurrentLocation {
    return Intl.message(
      'Enter your current location as it is written on your passport or national identity card.',
      name: 'spellCurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain a letter and a number, and be minimum of 8 characters`
  String get passwordConditions {
    return Intl.message(
      'Password must contain a letter and a number, and be minimum of 8 characters',
      name: 'passwordConditions',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Birthday as it is written on your passport or national identity card.`
  String get birthDayCondition {
    return Intl.message(
      'Enter your Birthday as it is written on your passport or national identity card.',
      name: 'birthDayCondition',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `The account already exists for that email`
  String get theAccountAlready {
    return Intl.message(
      'The account already exists for that email',
      name: 'theAccountAlready',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to our Team`
  String get welcomeToOurteam {
    return Intl.message(
      'Welcome to our Team',
      name: 'welcomeToOurteam',
      desc: '',
      args: [],
    );
  }

  /// `Reporter`
  String get journalistReporter {
    return Intl.message(
      'Reporter',
      name: 'journalistReporter',
      desc: '',
      args: [],
    );
  }

  /// `Journalist and Writer`
  String get journalistWriter {
    return Intl.message(
      'Journalist and Writer',
      name: 'journalistWriter',
      desc: '',
      args: [],
    );
  }

  /// `Tv Presenter`
  String get journalistAnimator {
    return Intl.message(
      'Tv Presenter',
      name: 'journalistAnimator',
      desc: '',
      args: [],
    );
  }

  /// `PhotoJournalist`
  String get photoJournalist {
    return Intl.message(
      'PhotoJournalist',
      name: 'photoJournalist',
      desc: '',
      args: [],
    );
  }

  /// `Journalist and Editor`
  String get journalistEditor {
    return Intl.message(
      'Journalist and Editor',
      name: 'journalistEditor',
      desc: '',
      args: [],
    );
  }

  /// `Online Journalist`
  String get onlineJournalistBloger {
    return Intl.message(
      'Online Journalist',
      name: 'onlineJournalistBloger',
      desc: '',
      args: [],
    );
  }

  /// `Tv Columnist`
  String get tvColumnist {
    return Intl.message(
      'Tv Columnist',
      name: 'tvColumnist',
      desc: '',
      args: [],
    );
  }

  /// `Freelance  Journalist`
  String get freelanceJournalist {
    return Intl.message(
      'Freelance  Journalist',
      name: 'freelanceJournalist',
      desc: '',
      args: [],
    );
  }

  /// `Investigative Journalist`
  String get investigativeJournalist {
    return Intl.message(
      'Investigative Journalist',
      name: 'investigativeJournalist',
      desc: '',
      args: [],
    );
  }

  /// `Politician`
  String get politician {
    return Intl.message(
      'Politician',
      name: 'politician',
      desc: '',
      args: [],
    );
  }

  /// `Searcher`
  String get sercher {
    return Intl.message(
      'Searcher',
      name: 'sercher',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get formIdentifierLoginPage {
    return Intl.message(
      'Email Address',
      name: 'formIdentifierLoginPage',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get formPasswordLoginPage {
    return Intl.message(
      'Password',
      name: 'formPasswordLoginPage',
      desc: '',
      args: [],
    );
  }

  /// `Or (Only Reader)`
  String get onlyReaderOptionSignIn {
    return Intl.message(
      'Or (Only Reader)',
      name: 'onlyReaderOptionSignIn',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password ?`
  String get forgotPasswordLoginPage {
    return Intl.message(
      'Forgot Password ?',
      name: 'forgotPasswordLoginPage',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account ?`
  String get askForSignUpLoginPage {
    return Intl.message(
      'Don\'t have an account ?',
      name: 'askForSignUpLoginPage',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUpFlatButtonLoginPage {
    return Intl.message(
      'Sign Up',
      name: 'signUpFlatButtonLoginPage',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get connectButtonLoginPage {
    return Intl.message(
      'Log In',
      name: 'connectButtonLoginPage',
      desc: '',
      args: [],
    );
  }

  /// `No user found for that identifier`
  String get snackBarNoUserFound {
    return Intl.message(
      'No user found for that identifier',
      name: 'snackBarNoUserFound',
      desc: '',
      args: [],
    );
  }

  /// `Wrong Password`
  String get snackBarWrongPassword {
    return Intl.message(
      'Wrong Password',
      name: 'snackBarWrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get appBarTitleResetPassword {
    return Intl.message(
      'Reset Password',
      name: 'appBarTitleResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Step 1 : Find Your Account`
  String get subtitleResetPassword {
    return Intl.message(
      'Step 1 : Find Your Account',
      name: 'subtitleResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `We just need your registered email to send you password reset code`
  String get descriptionResetPassword {
    return Intl.message(
      'We just need your registered email to send you password reset code',
      name: 'descriptionResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Email correctly`
  String get hintTextResetPassword {
    return Intl.message(
      'Enter your Email correctly',
      name: 'hintTextResetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Step 2 : Verification Code`
  String get subtitlePassCode {
    return Intl.message(
      'Step 2 : Verification Code',
      name: 'subtitlePassCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verification code we just sent you on your registered`
  String get descriptionPassCode {
    return Intl.message(
      'Enter the verification code we just sent you on your registered',
      name: 'descriptionPassCode',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get hintTextPassCode {
    return Intl.message(
      'Code',
      name: 'hintTextPassCode',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code !`
  String get resendCodeFlatButtonPassCode {
    return Intl.message(
      'Resend Code !',
      name: 'resendCodeFlatButtonPassCode',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verifybuttonPassCode {
    return Intl.message(
      'Verify',
      name: 'verifybuttonPassCode',
      desc: '',
      args: [],
    );
  }

  /// `Step 3 : Create New Password`
  String get subtitleCreateNewPassword {
    return Intl.message(
      'Step 3 : Create New Password',
      name: 'subtitleCreateNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `your new password must be different from the previously used password`
  String get descriptionCreateNewPassword {
    return Intl.message(
      'your new password must be different from the previously used password',
      name: 'descriptionCreateNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get hintTextNewPassword {
    return Intl.message(
      'New Password',
      name: 'hintTextNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get hintTextConfirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'hintTextConfirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Yes, It's me`
  String get yesItsMeButton {
    return Intl.message(
      'Yes, It\'s me',
      name: 'yesItsMeButton',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgainButton {
    return Intl.message(
      'Try again',
      name: 'tryAgainButton',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, no account is attached to this email`
  String get noAccountAttachedDes {
    return Intl.message(
      'Sorry, no account is attached to this email',
      name: 'noAccountAttachedDes',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm the password`
  String get taostConfirmThePassWord {
    return Intl.message(
      'Please confirm the password',
      name: 'taostConfirmThePassWord',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Code`
  String get toastInvalidCode {
    return Intl.message(
      'Invalid Code',
      name: 'toastInvalidCode',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up Mode`
  String get appBarTitleSignUpMode {
    return Intl.message(
      'Sign Up Mode',
      name: 'appBarTitleSignUpMode',
      desc: '',
      args: [],
    );
  }

  /// `Who are you ?`
  String get subtitleSignUpMode {
    return Intl.message(
      'Who are you ?',
      name: 'subtitleSignUpMode',
      desc: '',
      args: [],
    );
  }

  /// `you are ready to join us as a journalist, reader, or Media`
  String get descriptionSignUpMode {
    return Intl.message(
      'you are ready to join us as a journalist, reader, or Media',
      name: 'descriptionSignUpMode',
      desc: '',
      args: [],
    );
  }

  /// `I'am Reader`
  String get iamReaderSignUpMode {
    return Intl.message(
      'I\'am Reader',
      name: 'iamReaderSignUpMode',
      desc: '',
      args: [],
    );
  }

  /// `I'am Journalist`
  String get iamJournalistSignUpMode {
    return Intl.message(
      'I\'am Journalist',
      name: 'iamJournalistSignUpMode',
      desc: '',
      args: [],
    );
  }

  /// `We are Media`
  String get weareMediaSignUpMode {
    return Intl.message(
      'We are Media',
      name: 'weareMediaSignUpMode',
      desc: '',
      args: [],
    );
  }

  /// `The Same in the Identifier`
  String get hintTextFullNameSignUpWithEmail {
    return Intl.message(
      'The Same in the Identifier',
      name: 'hintTextFullNameSignUpWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullNameTitleSignUpWithEmail {
    return Intl.message(
      'Full Name',
      name: 'fullNameTitleSignUpWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `The Official Email Address`
  String get emailTitleSignUpWithEmail {
    return Intl.message(
      'The Official Email Address',
      name: 'emailTitleSignUpWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `The Current Location`
  String get locationTitleSignUpWithEmail {
    return Intl.message(
      'The Current Location',
      name: 'locationTitleSignUpWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get genderSignUpWithEmail {
    return Intl.message(
      'Gender',
      name: 'genderSignUpWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Country,  City`
  String get hintTextGetLocationSignUpWithEmail {
    return Intl.message(
      'Country,  City',
      name: 'hintTextGetLocationSignUpWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `teltrue-name@exemple.com`
  String get hintTextIdentifierSignUpWithEmail {
    return Intl.message(
      'teltrue-name@exemple.com',
      name: 'hintTextIdentifierSignUpWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get hintTextPasswordSignUpWithEmail {
    return Intl.message(
      'Password',
      name: 'hintTextPasswordSignUpWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get hintTextConfirmPasswordSignUpWithEmail {
    return Intl.message(
      'Confirm Password',
      name: 'hintTextConfirmPasswordSignUpWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get hintTextSelectMale {
    return Intl.message(
      'Male',
      name: 'hintTextSelectMale',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get hintTextSelectFemale {
    return Intl.message(
      'Female',
      name: 'hintTextSelectFemale',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get nextButton {
    return Intl.message(
      'Next',
      name: 'nextButton',
      desc: '',
      args: [],
    );
  }

  /// `Enter your full name !`
  String get snackBarInvalidFullName {
    return Intl.message(
      'Enter your full name !',
      name: 'snackBarInvalidFullName',
      desc: '',
      args: [],
    );
  }

  /// `Enter valid  Email address !`
  String get snackBarInvalidEmail {
    return Intl.message(
      'Enter valid  Email address !',
      name: 'snackBarInvalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password must have 8 characters !`
  String get snackBarInvalidPassword {
    return Intl.message(
      'Password must have 8 characters !',
      name: 'snackBarInvalidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your password`
  String get snackBarInvalidConfirmPassword {
    return Intl.message(
      'Confirm your password',
      name: 'snackBarInvalidConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your current Location`
  String get snackBarInvalidLocation {
    return Intl.message(
      'Enter your current Location',
      name: 'snackBarInvalidLocation',
      desc: '',
      args: [],
    );
  }

  /// `Workspace Name`
  String get subtitleJournalistSignUpWorkSpace {
    return Intl.message(
      'Workspace Name',
      name: 'subtitleJournalistSignUpWorkSpace',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get subtitleJournalistSignUpBirthday {
    return Intl.message(
      'Date of Birth',
      name: 'subtitleJournalistSignUpBirthday',
      desc: '',
      args: [],
    );
  }

  /// `Upload your Photo ID`
  String get subtitleJournalistSignUpUploadId {
    return Intl.message(
      'Upload your Photo ID',
      name: 'subtitleJournalistSignUpUploadId',
      desc: '',
      args: [],
    );
  }

  /// `Tv or Radio or Newspaper...`
  String get hintTextChannelNameJournalistSignUp {
    return Intl.message(
      'Tv or Radio or Newspaper...',
      name: 'hintTextChannelNameJournalistSignUp',
      desc: '',
      args: [],
    );
  }

  /// `To make sure of your identity, We need you to upload a color photo of your government-issued id. Your Id should include your name, day of Birth, and photo. \nacceptable Ids include your: \n- Passport \n- National Id card \n- driver's license \nOnce we received and reviewed a clear photo of your Id we will delete your  Identification document from our server`
  String get descriptionUploadPhotoId {
    return Intl.message(
      'To make sure of your identity, We need you to upload a color photo of your government-issued id. Your Id should include your name, day of Birth, and photo. \nacceptable Ids include your: \n- Passport \n- National Id card \n- driver\'s license \nOnce we received and reviewed a clear photo of your Id we will delete your  Identification document from our server',
      name: 'descriptionUploadPhotoId',
      desc: '',
      args: [],
    );
  }

  /// `Choose Photo`
  String get choosePhotoButton {
    return Intl.message(
      'Choose Photo',
      name: 'choosePhotoButton',
      desc: '',
      args: [],
    );
  }

  /// `image uploaded successfully`
  String get snackBarUploadImageId {
    return Intl.message(
      'image uploaded successfully',
      name: 'snackBarUploadImageId',
      desc: '',
      args: [],
    );
  }

  /// `Enter the valid day of Birth!`
  String get snackBarInvalidBirthday {
    return Intl.message(
      'Enter the valid day of Birth!',
      name: 'snackBarInvalidBirthday',
      desc: '',
      args: [],
    );
  }

  /// `Enter valid Start day !`
  String get snackBarSince {
    return Intl.message(
      'Enter valid Start day !',
      name: 'snackBarSince',
      desc: '',
      args: [],
    );
  }

  /// `You must upload your identity photo`
  String get snackBarInvalidUpload {
    return Intl.message(
      'You must upload your identity photo',
      name: 'snackBarInvalidUpload',
      desc: '',
      args: [],
    );
  }

  /// `You must choose One of Option `
  String get snackBarSelectOption {
    return Intl.message(
      'You must choose One of Option ',
      name: 'snackBarSelectOption',
      desc: '',
      args: [],
    );
  }

  /// `Profile Image`
  String get appBarTitleAddProfileImage {
    return Intl.message(
      'Profile Image',
      name: 'appBarTitleAddProfileImage',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully registered in our app and can start working on it`
  String get subtitleWelcomePage {
    return Intl.message(
      'You have successfully registered in our app and can start working on it',
      name: 'subtitleWelcomePage',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get startButton {
    return Intl.message(
      'Start',
      name: 'startButton',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get photoCamera {
    return Intl.message(
      'Camera',
      name: 'photoCamera',
      desc: '',
      args: [],
    );
  }

  /// `Suggestion to follow`
  String get appBarTitleSuggestion {
    return Intl.message(
      'Suggestion to follow',
      name: 'appBarTitleSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Select some topics you’re interested in to help personalize your Telltrue experience, starting with finding a journalist or Media to follow.`
  String get descriptionSuggestion {
    return Intl.message(
      'Select some topics you’re interested in to help personalize your Telltrue experience, starting with finding a journalist or Media to follow.',
      name: 'descriptionSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Journalists of `
  String get subtitleSuggestion1 {
    return Intl.message(
      'Journalists of ',
      name: 'subtitleSuggestion1',
      desc: '',
      args: [],
    );
  }

  /// `Television and Radio `
  String get subtitleSuggestion2 {
    return Intl.message(
      'Television and Radio ',
      name: 'subtitleSuggestion2',
      desc: '',
      args: [],
    );
  }

  /// `Newspaper and Magazines `
  String get subtitleSuggestion3 {
    return Intl.message(
      'Newspaper and Magazines ',
      name: 'subtitleSuggestion3',
      desc: '',
      args: [],
    );
  }

  /// `No journalist from your country has registered yet`
  String get noJournalistYet {
    return Intl.message(
      'No journalist from your country has registered yet',
      name: 'noJournalistYet',
      desc: '',
      args: [],
    );
  }

  /// `No Tv or Radio from your country has registered yet`
  String get noTvRadioYet {
    return Intl.message(
      'No Tv or Radio from your country has registered yet',
      name: 'noTvRadioYet',
      desc: '',
      args: [],
    );
  }

  /// `No Newspaper or Magazine from your country has registered yet`
  String get noNewspaperMagazine {
    return Intl.message(
      'No Newspaper or Magazine from your country has registered yet',
      name: 'noNewspaperMagazine',
      desc: '',
      args: [],
    );
  }

  /// `Account Menu`
  String get appBarTitleAccountMenu {
    return Intl.message(
      'Account Menu',
      name: 'appBarTitleAccountMenu',
      desc: '',
      args: [],
    );
  }

  /// `Reading`
  String get profileRead {
    return Intl.message(
      'Reading',
      name: 'profileRead',
      desc: '',
      args: [],
    );
  }

  /// `Publications`
  String get profilePublications {
    return Intl.message(
      'Publications',
      name: 'profilePublications',
      desc: '',
      args: [],
    );
  }

  /// `Suggestion`
  String get profileSuggestion {
    return Intl.message(
      'Suggestion',
      name: 'profileSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe`
  String get profileFollow {
    return Intl.message(
      'Subscribe',
      name: 'profileFollow',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get profileReviews {
    return Intl.message(
      'Reviews',
      name: 'profileReviews',
      desc: '',
      args: [],
    );
  }

  /// `Invite to Read`
  String get profileInviteToRead {
    return Intl.message(
      'Invite to Read',
      name: 'profileInviteToRead',
      desc: '',
      args: [],
    );
  }

  /// `So, if you have news or you are a witness...you can suggest it to your Prefer Journalist with Images, Videos or Documents.`
  String get profileSuggestionIntro {
    return Intl.message(
      'So, if you have news or you are a witness...you can suggest it to your Prefer Journalist with Images, Videos or Documents.',
      name: 'profileSuggestionIntro',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get profileSuggestionSubjectHint {
    return Intl.message(
      'Subject',
      name: 'profileSuggestionSubjectHint',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get profileSuggestiondescription {
    return Intl.message(
      'Description',
      name: 'profileSuggestiondescription',
      desc: '',
      args: [],
    );
  }

  /// `Add Evidence`
  String get profileSuggestionAddEvidence {
    return Intl.message(
      'Add Evidence',
      name: 'profileSuggestionAddEvidence',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get profileSuggestionSendButton {
    return Intl.message(
      'Send',
      name: 'profileSuggestionSendButton',
      desc: '',
      args: [],
    );
  }

  /// `Unsubscribe from `
  String get profileUnfollowRequest {
    return Intl.message(
      'Unsubscribe from ',
      name: 'profileUnfollowRequest',
      desc: '',
      args: [],
    );
  }

  /// `Identifier`
  String get profileContactsIdentifier {
    return Intl.message(
      'Identifier',
      name: 'profileContactsIdentifier',
      desc: '',
      args: [],
    );
  }

  /// `View Profile`
  String get viewProfile {
    return Intl.message(
      'View Profile',
      name: 'viewProfile',
      desc: '',
      args: [],
    );
  }

  /// `Delete Conversation`
  String get deleteConversation {
    return Intl.message(
      'Delete Conversation',
      name: 'deleteConversation',
      desc: '',
      args: [],
    );
  }

  /// `Block message`
  String get blockMessage {
    return Intl.message(
      'Block message',
      name: 'blockMessage',
      desc: '',
      args: [],
    );
  }

  /// `Breaking News`
  String get createPostBreakingNewsTitle {
    return Intl.message(
      'Breaking News',
      name: 'createPostBreakingNewsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Breaking news title`
  String get addPostBreakingNewsTitleHint {
    return Intl.message(
      'Breaking news title',
      name: 'addPostBreakingNewsTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Tell us What's Happened `
  String get addPostBreakingNewsDesHint {
    return Intl.message(
      'Tell us What\'s Happened ',
      name: 'addPostBreakingNewsDesHint',
      desc: '',
      args: [],
    );
  }

  /// `Type to search`
  String get tagTypeToSearch {
    return Intl.message(
      'Type to search',
      name: 'tagTypeToSearch',
      desc: '',
      args: [],
    );
  }

  /// `No tag search found`
  String get tagNoTagSearchFound {
    return Intl.message(
      'No tag search found',
      name: 'tagNoTagSearchFound',
      desc: '',
      args: [],
    );
  }

  /// `Teltrue people are posting about this`
  String get tagSearchNumberOf {
    return Intl.message(
      'Teltrue people are posting about this',
      name: 'tagSearchNumberOf',
      desc: '',
      args: [],
    );
  }

  /// `Use This`
  String get useButton {
    return Intl.message(
      'Use This',
      name: 'useButton',
      desc: '',
      args: [],
    );
  }

  /// `Article`
  String get createPostArticleTitle {
    return Intl.message(
      'Article',
      name: 'createPostArticleTitle',
      desc: '',
      args: [],
    );
  }

  /// `Broadcasting`
  String get createPostBroadcastTitle {
    return Intl.message(
      'Broadcasting',
      name: 'createPostBroadcastTitle',
      desc: '',
      args: [],
    );
  }

  /// `In Picture`
  String get createPostInpicTitle {
    return Intl.message(
      'In Picture',
      name: 'createPostInpicTitle',
      desc: '',
      args: [],
    );
  }

  /// `Investigation`
  String get createPostInvestigationTitle {
    return Intl.message(
      'Investigation',
      name: 'createPostInvestigationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Event`
  String get createPostEventTitle {
    return Intl.message(
      'Event',
      name: 'createPostEventTitle',
      desc: '',
      args: [],
    );
  }

  /// `Commentary & Perspectives`
  String get createPostCommentary {
    return Intl.message(
      'Commentary & Perspectives',
      name: 'createPostCommentary',
      desc: '',
      args: [],
    );
  }

  /// `feel`
  String get feel {
    return Intl.message(
      'feel',
      name: 'feel',
      desc: '',
      args: [],
    );
  }

  /// `Share a Journalism Interview, reportage, or live streaming about an event with a short description`
  String get createPostBroadCastDes {
    return Intl.message(
      'Share a Journalism Interview, reportage, or live streaming about an event with a short description',
      name: 'createPostBroadCastDes',
      desc: '',
      args: [],
    );
  }

  /// `Make picture talk !`
  String get createPostInPicDes {
    return Intl.message(
      'Make picture talk !',
      name: 'createPostInPicDes',
      desc: '',
      args: [],
    );
  }

  /// `Share your Investigation about crime or about actual  phenomenon or about Disaster with true proves or witnessing`
  String get createPostInvestigationDes {
    return Intl.message(
      'Share your Investigation about crime or about actual  phenomenon or about Disaster with true proves or witnessing',
      name: 'createPostInvestigationDes',
      desc: '',
      args: [],
    );
  }

  /// `Planning a cultural event or work event`
  String get createPostEvent {
    return Intl.message(
      'Planning a cultural event or work event',
      name: 'createPostEvent',
      desc: '',
      args: [],
    );
  }

  /// `Breaking news for today`
  String get createPostBreakingNewsDes {
    return Intl.message(
      'Breaking news for today',
      name: 'createPostBreakingNewsDes',
      desc: '',
      args: [],
    );
  }

  /// `Latest news`
  String get createPostLastestNewsTitle {
    return Intl.message(
      'Latest news',
      name: 'createPostLastestNewsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Find the latest news and information on the top stories, weather, business, entertainment, politics, and more.`
  String get createPostLastestNewsDes {
    return Intl.message(
      'Find the latest news and information on the top stories, weather, business, entertainment, politics, and more.',
      name: 'createPostLastestNewsDes',
      desc: '',
      args: [],
    );
  }

  /// `Commentaries are usually short articles that consist of 1,000 to 1,500 words, and they draw attention to, or critique a book, report, or article that is already published.`
  String get createPostCommentaryDes {
    return Intl.message(
      'Commentaries are usually short articles that consist of 1,000 to 1,500 words, and they draw attention to, or critique a book, report, or article that is already published.',
      name: 'createPostCommentaryDes',
      desc: '',
      args: [],
    );
  }

  /// `Essay`
  String get createPostEssay {
    return Intl.message(
      'Essay',
      name: 'createPostEssay',
      desc: '',
      args: [],
    );
  }

  /// `Most essays are short to medium-length pieces about a personal experience or an opinion. Typically, an essay revolves around one subject and presents your views.`
  String get createPostEssayDes {
    return Intl.message(
      'Most essays are short to medium-length pieces about a personal experience or an opinion. Typically, an essay revolves around one subject and presents your views.',
      name: 'createPostEssayDes',
      desc: '',
      args: [],
    );
  }

  /// `These prescriptive pieces contain steps, ways, or tips that help the reader do something specific. They provide the Rx (solution) for a problem or the answer to a question`
  String get createPostHowToDes {
    return Intl.message(
      'These prescriptive pieces contain steps, ways, or tips that help the reader do something specific. They provide the Rx (solution) for a problem or the answer to a question',
      name: 'createPostHowToDes',
      desc: '',
      args: [],
    );
  }

  /// `This type of article revolves around a person’s life (not yours) and accomplishments. Based on an interview, you provide an in-depth look at her life...`
  String get createPostProfileDes {
    return Intl.message(
      'This type of article revolves around a person’s life (not yours) and accomplishments. Based on an interview, you provide an in-depth look at her life...',
      name: 'createPostProfileDes',
      desc: '',
      args: [],
    );
  }

  /// `Review articles present a constructive and critical analysis of existing literature, accomplished through analysis, comparison, and summary. They can identify specific problems or gaps and can even provide recommendations for research in the future.`
  String get createPostAnalysisDes {
    return Intl.message(
      'Review articles present a constructive and critical analysis of existing literature, accomplished through analysis, comparison, and summary. They can identify specific problems or gaps and can even provide recommendations for research in the future.',
      name: 'createPostAnalysisDes',
      desc: '',
      args: [],
    );
  }

  /// `Tale, News, History, Legend, Science Fiction, Short Story, Tragedy, Comedy`
  String get createPostStoryDes {
    return Intl.message(
      'Tale, News, History, Legend, Science Fiction, Short Story, Tragedy, Comedy',
      name: 'createPostStoryDes',
      desc: '',
      args: [],
    );
  }

  /// `Sponsored`
  String get createPostSponsored {
    return Intl.message(
      'Sponsored',
      name: 'createPostSponsored',
      desc: '',
      args: [],
    );
  }

  /// `Sponsored content articles are, in essence, a type of advertising. They look and read like regular editorials, but they are paid for by a specific advertiser and therefore`
  String get createPostSponsoredDes {
    return Intl.message(
      'Sponsored content articles are, in essence, a type of advertising. They look and read like regular editorials, but they are paid for by a specific advertiser and therefore',
      name: 'createPostSponsoredDes',
      desc: '',
      args: [],
    );
  }

  /// `research articles are very detailed studies that report the original research. Considered primary literature, original research articles include the background study, methods, hypothesis, results, and the interpretation of the findings`
  String get createPostArticleDes {
    return Intl.message(
      'research articles are very detailed studies that report the original research. Considered primary literature, original research articles include the background study, methods, hypothesis, results, and the interpretation of the findings',
      name: 'createPostArticleDes',
      desc: '',
      args: [],
    );
  }

  /// `Find the place`
  String get addPostSearchPlaceHint {
    return Intl.message(
      'Find the place',
      name: 'addPostSearchPlaceHint',
      desc: '',
      args: [],
    );
  }

  /// `Find the current event title`
  String get addPostSearchEventHint {
    return Intl.message(
      'Find the current event title',
      name: 'addPostSearchEventHint',
      desc: '',
      args: [],
    );
  }

  /// `Find the famous person name`
  String get addPostSearchPersonHint {
    return Intl.message(
      'Find the famous person name',
      name: 'addPostSearchPersonHint',
      desc: '',
      args: [],
    );
  }

  /// `Famous person`
  String get tagPerson {
    return Intl.message(
      'Famous person',
      name: 'tagPerson',
      desc: '',
      args: [],
    );
  }

  /// `Event`
  String get tagEvent {
    return Intl.message(
      'Event',
      name: 'tagEvent',
      desc: '',
      args: [],
    );
  }

  /// `Place`
  String get tagPlace {
    return Intl.message(
      'Place',
      name: 'tagPlace',
      desc: '',
      args: [],
    );
  }

  /// `You must Select Topic`
  String get snackBarTopic {
    return Intl.message(
      'You must Select Topic',
      name: 'snackBarTopic',
      desc: '',
      args: [],
    );
  }

  /// `Ask something`
  String get askQuestionTitleHint {
    return Intl.message(
      'Ask something',
      name: 'askQuestionTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Opinion polls are similar to surveys or an inquiry designed to gauge public opinion about a specific issue or a series of issues in a scientific and unbiased manner.`
  String get createPostQuestionDes {
    return Intl.message(
      'Opinion polls are similar to surveys or an inquiry designed to gauge public opinion about a specific issue or a series of issues in a scientific and unbiased manner.',
      name: 'createPostQuestionDes',
      desc: '',
      args: [],
    );
  }

  /// `happy`
  String get feelingHappy {
    return Intl.message(
      'happy',
      name: 'feelingHappy',
      desc: '',
      args: [],
    );
  }

  /// `cool`
  String get feelingCool {
    return Intl.message(
      'cool',
      name: 'feelingCool',
      desc: '',
      args: [],
    );
  }

  /// `surprised`
  String get feelingSurprised {
    return Intl.message(
      'surprised',
      name: 'feelingSurprised',
      desc: '',
      args: [],
    );
  }

  /// `shocked`
  String get feelingShocked {
    return Intl.message(
      'shocked',
      name: 'feelingShocked',
      desc: '',
      args: [],
    );
  }

  /// `nervous`
  String get feelingNervous {
    return Intl.message(
      'nervous',
      name: 'feelingNervous',
      desc: '',
      args: [],
    );
  }

  /// `angry`
  String get feelingAngry {
    return Intl.message(
      'angry',
      name: 'feelingAngry',
      desc: '',
      args: [],
    );
  }

  /// `drool`
  String get feelingDrool {
    return Intl.message(
      'drool',
      name: 'feelingDrool',
      desc: '',
      args: [],
    );
  }

  /// `sweating`
  String get feelingSweat {
    return Intl.message(
      'sweating',
      name: 'feelingSweat',
      desc: '',
      args: [],
    );
  }

  /// `crying`
  String get feelingCrying {
    return Intl.message(
      'crying',
      name: 'feelingCrying',
      desc: '',
      args: [],
    );
  }

  /// `sad`
  String get feelingSad {
    return Intl.message(
      'sad',
      name: 'feelingSad',
      desc: '',
      args: [],
    );
  }

  /// `dead`
  String get feelingDead {
    return Intl.message(
      'dead',
      name: 'feelingDead',
      desc: '',
      args: [],
    );
  }

  /// `dubious`
  String get feelingDubious {
    return Intl.message(
      'dubious',
      name: 'feelingDubious',
      desc: '',
      args: [],
    );
  }

  /// `tired`
  String get feelingTired {
    return Intl.message(
      'tired',
      name: 'feelingTired',
      desc: '',
      args: [],
    );
  }

  /// `loved`
  String get feelingLoved {
    return Intl.message(
      'loved',
      name: 'feelingLoved',
      desc: '',
      args: [],
    );
  }

  /// `pain`
  String get feelingPain {
    return Intl.message(
      'pain',
      name: 'feelingPain',
      desc: '',
      args: [],
    );
  }

  /// `muted`
  String get feelingMuted {
    return Intl.message(
      'muted',
      name: 'feelingMuted',
      desc: '',
      args: [],
    );
  }

  /// `greed`
  String get feelingGreed {
    return Intl.message(
      'greed',
      name: 'feelingGreed',
      desc: '',
      args: [],
    );
  }

  /// `sick`
  String get feelingSick {
    return Intl.message(
      'sick',
      name: 'feelingSick',
      desc: '',
      args: [],
    );
  }

  /// `Poll`
  String get pollTitle {
    return Intl.message(
      'Poll',
      name: 'pollTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choice One`
  String get choiceOne {
    return Intl.message(
      'Choice One',
      name: 'choiceOne',
      desc: '',
      args: [],
    );
  }

  /// `Choice Two`
  String get choiceTwo {
    return Intl.message(
      'Choice Two',
      name: 'choiceTwo',
      desc: '',
      args: [],
    );
  }

  /// `Choice Three`
  String get choiceThree {
    return Intl.message(
      'Choice Three',
      name: 'choiceThree',
      desc: '',
      args: [],
    );
  }

  /// `Poll length`
  String get pollLength {
    return Intl.message(
      'Poll length',
      name: 'pollLength',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get days {
    return Intl.message(
      'days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get hours {
    return Intl.message(
      'Hours',
      name: 'hours',
      desc: '',
      args: [],
    );
  }

  /// `Minutes`
  String get Minutes {
    return Intl.message(
      'Minutes',
      name: 'Minutes',
      desc: '',
      args: [],
    );
  }

  /// `Discard Post`
  String get unDoneDialogDiscardPost {
    return Intl.message(
      'Discard Post',
      name: 'unDoneDialogDiscardPost',
      desc: '',
      args: [],
    );
  }

  /// `This can't be undone and you'll lose your draft.`
  String get unDoneDialogDiscardDes {
    return Intl.message(
      'This can\'t be undone and you\'ll lose your draft.',
      name: 'unDoneDialogDiscardDes',
      desc: '',
      args: [],
    );
  }

  /// `Discard`
  String get unDoneDialogDiscardButton {
    return Intl.message(
      'Discard',
      name: 'unDoneDialogDiscardButton',
      desc: '',
      args: [],
    );
  }

  /// `Breaking News`
  String get addPostBreakingNews {
    return Intl.message(
      'Breaking News',
      name: 'addPostBreakingNews',
      desc: '',
      args: [],
    );
  }

  /// `Opinion title`
  String get addPostOpiniontitle {
    return Intl.message(
      'Opinion title',
      name: 'addPostOpiniontitle',
      desc: '',
      args: [],
    );
  }

  /// `Analysis title`
  String get addPostAnalysistitle {
    return Intl.message(
      'Analysis title',
      name: 'addPostAnalysistitle',
      desc: '',
      args: [],
    );
  }

  /// `Investigation`
  String get addPostInvestigation {
    return Intl.message(
      'Investigation',
      name: 'addPostInvestigation',
      desc: '',
      args: [],
    );
  }

  /// `Feelings`
  String get feelingButton {
    return Intl.message(
      'Feelings',
      name: 'feelingButton',
      desc: '',
      args: [],
    );
  }

  /// `Topic`
  String get topicButton {
    return Intl.message(
      'Topic',
      name: 'topicButton',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get uploadButton {
    return Intl.message(
      'Upload',
      name: 'uploadButton',
      desc: '',
      args: [],
    );
  }

  /// `Article title`
  String get articleTitleHint {
    return Intl.message(
      'Article title',
      name: 'articleTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Investigation title`
  String get investigationTitleHint {
    return Intl.message(
      'Investigation title',
      name: 'investigationTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Photo/Video`
  String get picAndvidButton {
    return Intl.message(
      'Photo/Video',
      name: 'picAndvidButton',
      desc: '',
      args: [],
    );
  }

  /// `No pictures or videos added yet`
  String get mediaBoxIsEmptyLabel {
    return Intl.message(
      'No pictures or videos added yet',
      name: 'mediaBoxIsEmptyLabel',
      desc: '',
      args: [],
    );
  }

  /// `What do you Think `
  String get addPostOpinionHint {
    return Intl.message(
      'What do you Think ',
      name: 'addPostOpinionHint',
      desc: '',
      args: [],
    );
  }

  /// `Start your analysis`
  String get addPostAnalysisHint {
    return Intl.message(
      'Start your analysis',
      name: 'addPostAnalysisHint',
      desc: '',
      args: [],
    );
  }

  /// `Article Description`
  String get addPostArticleHint {
    return Intl.message(
      'Article Description',
      name: 'addPostArticleHint',
      desc: '',
      args: [],
    );
  }

  /// `Investigation details`
  String get addPostInvestigationHint {
    return Intl.message(
      'Investigation details',
      name: 'addPostInvestigationHint',
      desc: '',
      args: [],
    );
  }

  /// `Type your article's resources`
  String get addPostTypeResourcesHint {
    return Intl.message(
      'Type your article\'s resources',
      name: 'addPostTypeResourcesHint',
      desc: '',
      args: [],
    );
  }

  /// `Organize an event`
  String get addEventTitle {
    return Intl.message(
      'Organize an event',
      name: 'addEventTitle',
      desc: '',
      args: [],
    );
  }

  /// `Event title`
  String get addEventTitleHint {
    return Intl.message(
      'Event title',
      name: 'addEventTitleHint',
      desc: '',
      args: [],
    );
  }

  /// `Event Place`
  String get addEventPlaceLabel {
    return Intl.message(
      'Event Place',
      name: 'addEventPlaceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Hotel, Convention Hall, Street address, Online Event`
  String get addEventPlaceHint {
    return Intl.message(
      'Hotel, Convention Hall, Street address, Online Event',
      name: 'addEventPlaceHint',
      desc: '',
      args: [],
    );
  }

  /// `Animator`
  String get addEventSpeakerLabel {
    return Intl.message(
      'Animator',
      name: 'addEventSpeakerLabel',
      desc: '',
      args: [],
    );
  }

  /// `Speaker full name`
  String get addEventSpeakerHint {
    return Intl.message(
      'Speaker full name',
      name: 'addEventSpeakerHint',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get addEventDateLabel {
    return Intl.message(
      'Date',
      name: 'addEventDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get addEventMonthHint {
    return Intl.message(
      'Month',
      name: 'addEventMonthHint',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get addEventDayHint {
    return Intl.message(
      'Day',
      name: 'addEventDayHint',
      desc: '',
      args: [],
    );
  }

  /// `Start Time`
  String get addStartEventTime {
    return Intl.message(
      'Start Time',
      name: 'addStartEventTime',
      desc: '',
      args: [],
    );
  }

  /// `End Time`
  String get addEndEventTime {
    return Intl.message(
      'End Time',
      name: 'addEndEventTime',
      desc: '',
      args: [],
    );
  }

  /// `Event Poster`
  String get addEventPoster {
    return Intl.message(
      'Event Poster',
      name: 'addEventPoster',
      desc: '',
      args: [],
    );
  }

  /// `About Event...`
  String get addEventAboutHint {
    return Intl.message(
      'About Event...',
      name: 'addEventAboutHint',
      desc: '',
      args: [],
    );
  }

  /// `Start Live`
  String get startLiveButton {
    return Intl.message(
      'Start Live',
      name: 'startLiveButton',
      desc: '',
      args: [],
    );
  }

  /// `No video added yet`
  String get videoBoxIsEmptyLabel {
    return Intl.message(
      'No video added yet',
      name: 'videoBoxIsEmptyLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please Upload a Picture`
  String get snackBarUplodPicture {
    return Intl.message(
      'Please Upload a Picture',
      name: 'snackBarUplodPicture',
      desc: '',
      args: [],
    );
  }

  /// `Please Upload a video`
  String get snackBarUplodVideo {
    return Intl.message(
      'Please Upload a video',
      name: 'snackBarUplodVideo',
      desc: '',
      args: [],
    );
  }

  /// `Short Description`
  String get addStreamDescription {
    return Intl.message(
      'Short Description',
      name: 'addStreamDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please type a title  for article !`
  String get snackBarArticletitle {
    return Intl.message(
      'Please type a title  for article !',
      name: 'snackBarArticletitle',
      desc: '',
      args: [],
    );
  }

  /// `Please write your article !`
  String get snackBarArticleDes {
    return Intl.message(
      'Please write your article !',
      name: 'snackBarArticleDes',
      desc: '',
      args: [],
    );
  }

  /// `Please write your analysis !`
  String get snackBarAnalyisDes {
    return Intl.message(
      'Please write your analysis !',
      name: 'snackBarAnalyisDes',
      desc: '',
      args: [],
    );
  }

  /// `Please write your investigation !`
  String get snackBarInvestigationTitle {
    return Intl.message(
      'Please write your investigation !',
      name: 'snackBarInvestigationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please write your investigation !`
  String get snackBarInvestigationDes {
    return Intl.message(
      'Please write your investigation !',
      name: 'snackBarInvestigationDes',
      desc: '',
      args: [],
    );
  }

  /// `Please type a title for event !`
  String get snackBarEventTitle {
    return Intl.message(
      'Please type a title for event !',
      name: 'snackBarEventTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please type a place address !`
  String get snackBarEventPlace {
    return Intl.message(
      'Please type a place address !',
      name: 'snackBarEventPlace',
      desc: '',
      args: [],
    );
  }

  /// `Please type speakers names`
  String get snackBarSpeakerList {
    return Intl.message(
      'Please type speakers names',
      name: 'snackBarSpeakerList',
      desc: '',
      args: [],
    );
  }

  /// `Please type a valid date`
  String get snackBarValidDate {
    return Intl.message(
      'Please type a valid date',
      name: 'snackBarValidDate',
      desc: '',
      args: [],
    );
  }

  /// `Please type a valid start time !`
  String get snackBarValidStartTime {
    return Intl.message(
      'Please type a valid start time !',
      name: 'snackBarValidStartTime',
      desc: '',
      args: [],
    );
  }

  /// `Please type a valid end time`
  String get snackBarValidEndTime {
    return Intl.message(
      'Please type a valid end time',
      name: 'snackBarValidEndTime',
      desc: '',
      args: [],
    );
  }

  /// `Please upload a poster !`
  String get snackBarPoster {
    return Intl.message(
      'Please upload a poster !',
      name: 'snackBarPoster',
      desc: '',
      args: [],
    );
  }

  /// `Please write some words about event !`
  String get snackBarAbout {
    return Intl.message(
      'Please write some words about event !',
      name: 'snackBarAbout',
      desc: '',
      args: [],
    );
  }

  /// `  posted an`
  String get postedAn {
    return Intl.message(
      '  posted an',
      name: 'postedAn',
      desc: '',
      args: [],
    );
  }

  /// ` Picture`
  String get picture {
    return Intl.message(
      ' Picture',
      name: 'picture',
      desc: '',
      args: [],
    );
  }

  /// ` Video `
  String get video {
    return Intl.message(
      ' Video ',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `speaker`
  String get eventViewSpeaker {
    return Intl.message(
      'speaker',
      name: 'eventViewSpeaker',
      desc: '',
      args: [],
    );
  }

  /// `Ask by `
  String get postViewAskBy {
    return Intl.message(
      'Ask by ',
      name: 'postViewAskBy',
      desc: '',
      args: [],
    );
  }

  /// `Resources`
  String get resources {
    return Intl.message(
      'Resources',
      name: 'resources',
      desc: '',
      args: [],
    );
  }

  /// `Read`
  String get read {
    return Intl.message(
      'Read',
      name: 'read',
      desc: '',
      args: [],
    );
  }

  /// `Search friend`
  String get searchFriend {
    return Intl.message(
      'Search friend',
      name: 'searchFriend',
      desc: '',
      args: [],
    );
  }

  /// `Sent`
  String get sentButton {
    return Intl.message(
      'Sent',
      name: 'sentButton',
      desc: '',
      args: [],
    );
  }

  /// `How To ?`
  String get createHowToTitle {
    return Intl.message(
      'How To ?',
      name: 'createHowToTitle',
      desc: '',
      args: [],
    );
  }

  /// `Supplies`
  String get createHowToSuplliesHintText {
    return Intl.message(
      'Supplies',
      name: 'createHowToSuplliesHintText',
      desc: '',
      args: [],
    );
  }

  /// `Think in steps`
  String get createHowToThinkInStep {
    return Intl.message(
      'Think in steps',
      name: 'createHowToThinkInStep',
      desc: '',
      args: [],
    );
  }

  /// `Step title (Optional)`
  String get createHowToStepTitleHintText {
    return Intl.message(
      'Step title (Optional)',
      name: 'createHowToStepTitleHintText',
      desc: '',
      args: [],
    );
  }

  /// `Details of step`
  String get createHowToStepDetailsHintText {
    return Intl.message(
      'Details of step',
      name: 'createHowToStepDetailsHintText',
      desc: '',
      args: [],
    );
  }

  /// `Display result`
  String get createHowToShowResult {
    return Intl.message(
      'Display result',
      name: 'createHowToShowResult',
      desc: '',
      args: [],
    );
  }

  /// `Add step`
  String get createHowToAddStepButton {
    return Intl.message(
      'Add step',
      name: 'createHowToAddStepButton',
      desc: '',
      args: [],
    );
  }

  /// `You need to write down some supplies`
  String get snackBarSupplies {
    return Intl.message(
      'You need to write down some supplies',
      name: 'snackBarSupplies',
      desc: '',
      args: [],
    );
  }

  /// `you need to write down some steps`
  String get snackBarSteps {
    return Intl.message(
      'you need to write down some steps',
      name: 'snackBarSteps',
      desc: '',
      args: [],
    );
  }

  /// `Please write some word about`
  String get snackBarBiography {
    return Intl.message(
      'Please write some word about',
      name: 'snackBarBiography',
      desc: '',
      args: [],
    );
  }

  /// `Add paragraph`
  String get createAnalysisAddpart {
    return Intl.message(
      'Add paragraph',
      name: 'createAnalysisAddpart',
      desc: '',
      args: [],
    );
  }

  /// `Analysis and Review`
  String get createAnalysisTitle {
    return Intl.message(
      'Analysis and Review',
      name: 'createAnalysisTitle',
      desc: '',
      args: [],
    );
  }

  /// `Paragraph title`
  String get createAnalysisPartTitle {
    return Intl.message(
      'Paragraph title',
      name: 'createAnalysisPartTitle',
      desc: '',
      args: [],
    );
  }

  /// `Paragraph details`
  String get createAnalysisPartDetails {
    return Intl.message(
      'Paragraph details',
      name: 'createAnalysisPartDetails',
      desc: '',
      args: [],
    );
  }

  /// `Please type a title`
  String get snackBarEmptyTitle {
    return Intl.message(
      'Please type a title',
      name: 'snackBarEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please type some words in the description Box`
  String get snackBarEmptyDes {
    return Intl.message(
      'Please type some words in the description Box',
      name: 'snackBarEmptyDes',
      desc: '',
      args: [],
    );
  }

  /// `Please type one paragraph au minimum`
  String get snackBarEmptyParagraph {
    return Intl.message(
      'Please type one paragraph au minimum',
      name: 'snackBarEmptyParagraph',
      desc: '',
      args: [],
    );
  }

  /// `Broadcasting description`
  String get broadcastingHintTextDes {
    return Intl.message(
      'Broadcasting description',
      name: 'broadcastingHintTextDes',
      desc: '',
      args: [],
    );
  }

  /// `Picture description`
  String get inPictureHintTextDes {
    return Intl.message(
      'Picture description',
      name: 'inPictureHintTextDes',
      desc: '',
      args: [],
    );
  }

  /// `Story`
  String get createStoryTitle {
    return Intl.message(
      'Story',
      name: 'createStoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Story title (Optional)`
  String get createStorytitleHintText {
    return Intl.message(
      'Story title (Optional)',
      name: 'createStorytitleHintText',
      desc: '',
      args: [],
    );
  }

  /// `Write your story here`
  String get createStoryDesHintText {
    return Intl.message(
      'Write your story here',
      name: 'createStoryDesHintText',
      desc: '',
      args: [],
    );
  }

  /// `describe an opinion or personal experience`
  String get addPostEssayDesHintText {
    return Intl.message(
      'describe an opinion or personal experience',
      name: 'addPostEssayDesHintText',
      desc: '',
      args: [],
    );
  }

  /// `No content available`
  String get noContentAvailable {
    return Intl.message(
      'No content available',
      name: 'noContentAvailable',
      desc: '',
      args: [],
    );
  }

  /// `There are no other publications to display`
  String get noOtherPublication {
    return Intl.message(
      'There are no other publications to display',
      name: 'noOtherPublication',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get interestAll {
    return Intl.message(
      'All',
      name: 'interestAll',
      desc: '',
      args: [],
    );
  }

  /// `World`
  String get interestWorld {
    return Intl.message(
      'World',
      name: 'interestWorld',
      desc: '',
      args: [],
    );
  }

  /// `Business & Finance`
  String get interestBusiness {
    return Intl.message(
      'Business & Finance',
      name: 'interestBusiness',
      desc: '',
      args: [],
    );
  }

  /// `Lifestyle`
  String get interestLifestyle {
    return Intl.message(
      'Lifestyle',
      name: 'interestLifestyle',
      desc: '',
      args: [],
    );
  }

  /// `Computers Science & Technology`
  String get interestTechnology {
    return Intl.message(
      'Computers Science & Technology',
      name: 'interestTechnology',
      desc: '',
      args: [],
    );
  }

  /// `Sport`
  String get interestSport {
    return Intl.message(
      'Sport',
      name: 'interestSport',
      desc: '',
      args: [],
    );
  }

  /// `Health & Medicine`
  String get interestHealth {
    return Intl.message(
      'Health & Medicine',
      name: 'interestHealth',
      desc: '',
      args: [],
    );
  }

  /// `Science`
  String get interestScience {
    return Intl.message(
      'Science',
      name: 'interestScience',
      desc: '',
      args: [],
    );
  }

  /// `Entertainment`
  String get interestEntertainment {
    return Intl.message(
      'Entertainment',
      name: 'interestEntertainment',
      desc: '',
      args: [],
    );
  }

  /// `Agriculture`
  String get interestAgriculture {
    return Intl.message(
      'Agriculture',
      name: 'interestAgriculture',
      desc: '',
      args: [],
    );
  }

  /// `mechanical`
  String get interestMechanical {
    return Intl.message(
      'mechanical',
      name: 'interestMechanical',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get interestOther {
    return Intl.message(
      'Other',
      name: 'interestOther',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Watch`
  String get watch {
    return Intl.message(
      'Watch',
      name: 'watch',
      desc: '',
      args: [],
    );
  }

  /// `Trending`
  String get trending {
    return Intl.message(
      'Trending',
      name: 'trending',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Write`
  String get write {
    return Intl.message(
      'Write',
      name: 'write',
      desc: '',
      args: [],
    );
  }

  /// `Read later`
  String get readLater {
    return Intl.message(
      'Read later',
      name: 'readLater',
      desc: '',
      args: [],
    );
  }

  /// `Watch later`
  String get watchLater {
    return Intl.message(
      'Watch later',
      name: 'watchLater',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashbord {
    return Intl.message(
      'Dashboard',
      name: 'dashbord',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message(
      'Payment',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `Interests`
  String get profileInterest {
    return Intl.message(
      'Interests',
      name: 'profileInterest',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'el'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'pa'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}