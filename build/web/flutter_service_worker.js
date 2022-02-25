'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "43d7bcc23d97eaec7387e644323f2fa0",
"assets/assets/font/Avenir%2520Book.ttf": "9f784699e62f2b6ddc7a582f909edcc7",
"assets/assets/font/Courgette-Regular.ttf": "59c3685a73f0f1b7c302dd2d6dabd628",
"assets/assets/font/DancingScript-VariableFont_wght.ttf": "d3bebba97d549436fd6137d05d55ae33",
"assets/assets/font/FontsFree-Net-SFProDisplay-Thin.ttf": "49689c08ce2ad9a3d749766b184eb1de",
"assets/assets/font/FontsFree-Net-SFProText-Bold.ttf": "d6079ef01292c4bc84dce33988641530",
"assets/assets/font/FontsFree-Net-SFProText-Medium.ttf": "a260cbc18870da144038776461d9df28",
"assets/assets/font/FontsFree-Net-SFProText-Regular.ttf": "85bd46c1cff02c1d8360cc714b8298fa",
"assets/assets/font/KaushanScript-Regular.ttf": "bafd78da573962d22a817cf22678c8dc",
"assets/assets/font/Lora-VariableFont_wght.ttf": "337fa370c6ba675d1c9d3ba0d1444145",
"assets/assets/font/MarckScript-Regular.ttf": "4092ea4f72947cc3245883b3faf35339",
"assets/assets/font/Pacifico-Regular.ttf": "9b94499ccea3bd82b24cb210733c4b5e",
"assets/assets/font/Roboto-Light.ttf": "88823c2015ffd5fa89d567e17297a137",
"assets/assets/font/RobotoSlab-VariableFont_wght.ttf": "0b2aeb1c9f580b22533476443b47f0ad",
"assets/assets/font/Tajawal-Light.ttf": "fbca61ce5f0321ab500bdbb168b775b0",
"assets/assets/icons/012-arroba.svg": "6f3c45ce8efac5747ee017e50ce55c11",
"assets/assets/icons/022-file.svg": "deb07e0e8708618a7b5d4de32a67dd22",
"assets/assets/icons/031-photo%2520camera.svg": "4d3e864cab4fb667b69ffc595e250a1b",
"assets/assets/icons/036-check.svg": "0bbf4bfc8117ebae00663cb1c72df58e",
"assets/assets/icons/037-clapperboard.svg": "56717fec029c082f5df154bff73e6cc7",
"assets/assets/icons/048-credit%2520card.svg": "9972045fda98a1f7313dd032308f3e43",
"assets/assets/icons/066-planet-earth.svg": "2e3509581a2b6b936b8561c705e0bf73",
"assets/assets/icons/068-cancel.svg": "cecc47d777af5ada630e2dd951f698c5",
"assets/assets/icons/082-eyeglasses.svg": "f1e95c1fea784874a36c038f310fb0ed",
"assets/assets/icons/083-eye.svg": "5c05b66668757197d1920d8470ab1c10",
"assets/assets/icons/083-worldwide.svg": "54e80f79ae6f2d9a2bc077db4259ffab",
"assets/assets/icons/105-padlock.svg": "7dc40e72b5d0bcd86bc204788630a109",
"assets/assets/icons/108-logout.svg": "77c28ab8af83cf830e06fbfcee7dfc1c",
"assets/assets/icons/121-more.svg": "50d05f172d74d5dee2b765212a52a749",
"assets/assets/icons/142-paperclip.svg": "93162e1d911972a257365c698bbc944f",
"assets/assets/icons/150-picture.svg": "c610d3ee88f9d797113c18ca80fd6f48",
"assets/assets/icons/151-play.svg": "5b405d119c96973f368ee321ab66c33b",
"assets/assets/icons/160-question.svg": "cd0debcd324b65aae8ee325ec4a7de32",
"assets/assets/icons/172-loupe.svg": "0b48f16ecc961820b026d769c7144671",
"assets/assets/icons/174-settings.svg": "02cb9d112e665373d2fe141bf5430de4",
"assets/assets/icons/175-share.svg": "53513de24e4e6a44854929a21438d951",
"assets/assets/icons/194-dislike.svg": "9281537db947acce6aa3d74ce56372a4",
"assets/assets/icons/195-like.svg": "871b4e9cbe11436f1568c4cad640a44e",
"assets/assets/icons/218-video%2520camera.svg": "2c9c4c0de4bdba87420f0cdbeec7cb08",
"assets/assets/icons/add-friend.svg": "bfb882ac0589e8e02d40b5f3bd4c0eab",
"assets/assets/icons/Add1.svg": "a9b48028e925d1c3203311d2cd6c6f78",
"assets/assets/icons/alert.svg": "395425fd47006a380a0302be0a832410",
"assets/assets/icons/book.svg": "a747dfd545521ecf49048de9e0abae9e",
"assets/assets/icons/cancel.svg": "ad71654ba9fe7050381673d24ca97d2f",
"assets/assets/icons/chat_1.svg": "e658156f30a0ec7fe3800f8969673f91",
"assets/assets/icons/check.svg": "7ce5a227fd1eef07f2b5fb8213969d8a",
"assets/assets/icons/clock.svg": "06412bd8ae8f9110994a56e33b4f8c85",
"assets/assets/icons/cross.svg": "71f62e0a6ec4822fea31bf4e597006a5",
"assets/assets/icons/dot.svg": "894919291fba52e880a7d2b759f03fa9",
"assets/assets/icons/double-tick-indicator.svg": "5894bead31e51d7db68ee0bda475ea69",
"assets/assets/icons/down-arrow.svg": "e48ed1deec68d430406d7b4c934b0980",
"assets/assets/icons/edit.svg": "2927f8de4268bae8f11c4dfe3adc72b5",
"assets/assets/icons/enterprise.svg": "3a5cf14b40f3b7635b515faa1f6930e3",
"assets/assets/icons/envelope.svg": "4d9e5a2040325df11d9757258a7c9ba5",
"assets/assets/icons/eyeglasses.svg": "529c2bf5cde15928866f430e83b22406",
"assets/assets/icons/fast-time.svg": "f8fd0ed2305a34674a50f64ce9a82c7e",
"assets/assets/icons/file_format/cad.svg": "a9081763361f85a1c848092115a92b7f",
"assets/assets/icons/file_format/css.svg": "d7b3eafaf65bab6765e07870b5c6afaf",
"assets/assets/icons/file_format/dmg.svg": "e4f5e143c385323edaf482ce973e3da8",
"assets/assets/icons/file_format/doc.svg": "37a56acc8af5af7cb47aa748c7415dc3",
"assets/assets/icons/file_format/file.svg": "ffdb36f617b9a8f1e583262bdcc43628",
"assets/assets/icons/file_format/html.svg": "997d401f0a6084c9c088361b3e98ffe8",
"assets/assets/icons/file_format/iso.svg": "f49072e15f77bb592cf5cd33d0d05300",
"assets/assets/icons/file_format/js.svg": "1047d82843f314cc3bbcdb39ae18fc37",
"assets/assets/icons/file_format/mp3.svg": "5321b9ef47044d5af6e67764a4c7574a",
"assets/assets/icons/file_format/pdf.svg": "7d7b22ee63b0485a61b9af1ff8d57593",
"assets/assets/icons/file_format/php.svg": "93d6dcb91c2d825d0ada5991cf825c7b",
"assets/assets/icons/file_format/ppt.svg": "318bbb6606b403dc02d347e4f7a92729",
"assets/assets/icons/file_format/ps.svg": "41a1c54e3124a545d5786565e61c5641",
"assets/assets/icons/file_format/psd.svg": "7e4912b28a0335a23e0824fdf393003c",
"assets/assets/icons/file_format/sql.svg": "7ef812659cc8a21b8ed45e58cd02383e",
"assets/assets/icons/file_format/svg.svg": "b60c2c92617d5db68803a3db3150c33a",
"assets/assets/icons/file_format/txt.svg": "d8b68cb37424abbe6e14ea63f867c9d8",
"assets/assets/icons/file_format/xls.svg": "2724255e34c0f2172d2c3ba1ab0e16c9",
"assets/assets/icons/file_format/xml.svg": "9412787092e829f574f73ba0d67848c0",
"assets/assets/icons/file_format/zip.svg": "8cf194badb8e028fec1c3bb30ea5a4d5",
"assets/assets/icons/filter.svg": "1c44b26f44eef5f3e42a94388bbdd539",
"assets/assets/icons/fire.svg": "0b413c3dffc72a3510f273657eb93624",
"assets/assets/icons/graduation-cap.svg": "97ec4fb637c611ebf970777f704e9943",
"assets/assets/icons/house.svg": "991b5e5764282997bfe5a869f352f177",
"assets/assets/icons/image-gallery.svg": "656fc865728194af520053a0439b2995",
"assets/assets/icons/magnifying-glass.svg": "2e5a42b67203585d06c669540238ed4d",
"assets/assets/icons/menu-3.svg": "3472e67cfd211066256d860fbfff41fe",
"assets/assets/icons/monitor.svg": "8ee074b996da4054eb68b997b82b7ec5",
"assets/assets/icons/msg.svg": "c807c28aeda8617d7c51043d745555fb",
"assets/assets/icons/no-message.svg": "2d1482fc4c1d4f18f390a9b548aa8399",
"assets/assets/icons/notification.svg": "c5ccfa607eebe995af465cce70e8604a",
"assets/assets/icons/padlock.svg": "6ced8f2b38859381df52a56c5ea8ffca",
"assets/assets/icons/photo-camera.svg": "eceedf32373ce27e9f7a9ce3243ab221",
"assets/assets/icons/picture.svg": "1e1c8d1b0036a8b2e802801f9bea3d7a",
"assets/assets/icons/placeholder.svg": "fed93dd7513dd3ae5f49df6e88db676b",
"assets/assets/icons/questionMark.svg": "4a1026c0bd40eafa827c49288ca23497",
"assets/assets/icons/star.svg": "88688cf0265e297262d0cf7470c1609c",
"assets/assets/icons/streaming.svg": "781c43140d5e3dd6e4cc16837a00bc58",
"assets/assets/icons/suitcase.svg": "c9d99fd185a8c11ea1183a24d57d9b99",
"assets/assets/icons/touch.svg": "7ef37ed8b6ca34c9fda2fb51302bcaed",
"assets/assets/icons/upload-1.svg": "3cca0d1d7cdcc4ec38890016eba65513",
"assets/assets/icons/user.svg": "67d935671d3a25a01b2df9d723a5b363",
"assets/assets/icons/user_.svg": "c9fffa0eb79167d1f135114691d6a9a3",
"assets/assets/images/001-check.png": "4856ed48c1120a2cbe35ff7a9ee3368e",
"assets/assets/images/009-camera.png": "f93caba9235642700948d3963df1f5aa",
"assets/assets/images/009-video%2520camera.png": "0dea96dd5a4cdda59bdb57b464169cb9",
"assets/assets/images/026-pie-chart.png": "35f8285095bfd72ff50d82b64971c2ca",
"assets/assets/images/076-settings.png": "e6d98887d432096973656e66c5c97807",
"assets/assets/images/096-wallet.png": "ec576bc740325a3735e98e35b8e3578b",
"assets/assets/images/addImage.jpg": "888ff3143a05e0933b91eaad23230de1",
"assets/assets/images/addProfileImage.jpg": "17c214c0e301d2fcced7b0211e2a63e2",
"assets/assets/images/advertisement.png": "fe5f3cb5948955a4d7ba76fb5eefce25",
"assets/assets/images/apple.png": "315b229f7add9185f77942f6691c331a",
"assets/assets/images/businessman.png": "208e1f4a8d572f1e41caa7ac49c10baa",
"assets/assets/images/calendar.png": "8461ccb9a7c19150183fe3cc59958960",
"assets/assets/images/camera.png": "cc3b63dd97e99926a9d289314ee84a6d",
"assets/assets/images/check%2520(2).png": "c38d74598c0b3e67b3ab2e7d5b55e5a5",
"assets/assets/images/choice.jpg": "020dcbf052295d70500df71900915c87",
"assets/assets/images/choice.png": "2b462f4d8841b540b50c8e96b1fe078d",
"assets/assets/images/detective.png": "537bbbc324664db0d983615ecc264032",
"assets/assets/images/exclamation-mark.png": "2e7f5fa7d6656e24f24d23db7730014c",
"assets/assets/images/Facebook.png": "c3c2aea1bf8c45347a627e683423c8ab",
"assets/assets/images/fast-time.png": "2930e1286a9c9a5738b32bb0dc9d5550",
"assets/assets/images/feeling/001-happy-18.png": "083551524574cd5a22673e3faa2c831a",
"assets/assets/images/feeling/002-cool-5.png": "237245b816f2a0528b01ce5f7408130b",
"assets/assets/images/feeling/004-surprised-9.png": "1189901e18f849d176a0ddeca53ca6ed",
"assets/assets/images/feeling/005-shocked-4.png": "e837d2295b44385605c9a52a08f5d62a",
"assets/assets/images/feeling/007-nervous-2.png": "39281ef1047060d003335511775e8b3a",
"assets/assets/images/feeling/010-drool.png": "689389c179f896770fa1192a15fc7e71",
"assets/assets/images/feeling/013-tongue-6.png": "575c1d1e60d6a566f48140a800126c85",
"assets/assets/images/feeling/024-sweat-1.png": "1aa26598f588f367f6cbb65616bc4a0f",
"assets/assets/images/feeling/030-crying-8.png": "cd6dadffcf62d359a6989f70c925ceb0",
"assets/assets/images/feeling/035-sad-14.png": "8c9b1a98b7c97da40cc36d778cf96632",
"assets/assets/images/feeling/036-angry-4.png": "6fad1e15db0c4ad7c38afacc7357ad79",
"assets/assets/images/feeling/044-dead-1.png": "38d0ba549ee8a4baf6feddd776e90746",
"assets/assets/images/feeling/046-dubious.png": "435d71c384a44c1d6c5cfebf9272be5e",
"assets/assets/images/feeling/053-tired-1.png": "03a8602bfccbea6b84177bed866e8335",
"assets/assets/images/feeling/074-in-love-10.png": "fb1f9070335bfabe00e5542cc1ef9800",
"assets/assets/images/feeling/081-pain.png": "d261f198338bc1778bd35217a204ae84",
"assets/assets/images/feeling/101-nerd-8.png": "e00e2e0dae09a2cbc6a2d0e0a2402207",
"assets/assets/images/feeling/111-muted-3.png": "8aa4df94d8e9179864c49930e0f845d4",
"assets/assets/images/feeling/119-greed.png": "fe90279974d6db3da4c1ce2a9ed88b6e",
"assets/assets/images/feeling/151-sick-1.png": "945c6314e3083feb13fa219d5dfcbc7c",
"assets/assets/images/feeling/152-outrage.png": "7577747409416a27c19ed07f6ae519d3",
"assets/assets/images/feeling/171-thinking.png": "80b5210d3cd1494386754ed213155811",
"assets/assets/images/follow.png": "6b54f73cec7c74a822881ba7825cbc78",
"assets/assets/images/Google.png": "923c579e6e4e40f21b70d74f26281ed5",
"assets/assets/images/guide.png": "f744521346a62168ec8e6961e52143e8",
"assets/assets/images/hashtag.png": "37f86c983b923e3bcf446c26cad51b3b",
"assets/assets/images/idea.png": "a59cd4aa34936ec2bd7adf44ed8843f8",
"assets/assets/images/info.png": "5a4132d9928e88ef766952792c4e3a0c",
"assets/assets/images/Instagram.png": "4d1e7333155828ab3b800417c3ceede7",
"assets/assets/images/invitation.png": "08c3d3a76d7a042ae015f37417fd36dc",
"assets/assets/images/journalistKind/044-businessman-29.png": "803160b4085ec2cca9dd1f09d0dbabf8",
"assets/assets/images/journalistKind/135-businesswoman-3.png": "5b2bbff63346cd0b6f5fdb25795fb72a",
"assets/assets/images/journalistKind/150-man-20.png": "f34e091c288f44d58b6c1f241eaa9d05",
"assets/assets/images/journalistKind/214-businessman-4.png": "6eed48c64369ca46b659955fbdef33fe",
"assets/assets/images/journalistKind/bloger.png": "20063947950471de83963536247ad079",
"assets/assets/images/journalistKind/columinst.png": "f4ebb4a3c82a94ae02a032c0f47adb36",
"assets/assets/images/journalistKind/detective.png": "37df447546d78ab3a8eac34ca1f92905",
"assets/assets/images/journalistKind/editor.png": "af6714822457d182d11dba462bc30967",
"assets/assets/images/journalistKind/freeLance.png": "046670feb666a1c61044f34be9f0a72b",
"assets/assets/images/journalistKind/photo.png": "ef12cbb43fbec2f7286f7988fad492d4",
"assets/assets/images/journalistKind/politician.png": "e218e9364698c7e5d67bd1b36b29ed70",
"assets/assets/images/journalistKind/presenter.png": "a6e2fd0a9a26e84a63ce3373e1ca1ade",
"assets/assets/images/journalistKind/reporter.png": "edd3c81441a9994b6fa379a45ba51d00",
"assets/assets/images/journalistKind/searcher.png": "20b65dae16e410fd37b1ae97cb35db86",
"assets/assets/images/journalistKind/writer.png": "9d97eb6e47fdcd482b4b46de3cd5373e",
"assets/assets/images/jumio-1.jpg": "f66ba4911092d38bc5cff94ea5164045",
"assets/assets/images/light-bulb.png": "af1771537807e1e8640bbce825adaa47",
"assets/assets/images/LinkedIn.png": "20fbc66ece977a1d1f7b367062fe1b7f",
"assets/assets/images/live-streaming.png": "a6d255325de7d41a5f6959089772e69c",
"assets/assets/images/Mail.png": "61f5ea02e00461017c69b386f52487ca",
"assets/assets/images/man.png": "70a98395fd37b2663516831ea1407d42",
"assets/assets/images/message.png": "cab1e4a321063bf4608c56969a074f26",
"assets/assets/images/mortarboard.png": "09fa537f9f9a2b0c0397e1d4b09455fa",
"assets/assets/images/news.png": "397ce52f647868e9186d1ef5c84e49e3",
"assets/assets/images/news5.png": "5c2d2e805f2ae15886558028874eb25b",
"assets/assets/images/note.png": "dd07265e2d3fc732b144cf36f2ab8465",
"assets/assets/images/photo.png": "84afae9853b74f35a1f9718c56c93d22",
"assets/assets/images/pictures.png": "fc9602538def15eea1506c5bd2af360f",
"assets/assets/images/playstore.png": "8b279331e2c964c5e5593f94f8e393a6",
"assets/assets/images/post.png": "7120bb641eafcf8b451383d7371417a3",
"assets/assets/images/processus-kyc.png": "95d6337b01e365225bedfd0b52a430a4",
"assets/assets/images/question.png": "8769462122688a3a87baa7a5677771c1",
"assets/assets/images/question1.png": "ed8c98d591974974f5382610b9d52387",
"assets/assets/images/reading.png": "74f17da5741c970d67485ce1adc600e8",
"assets/assets/images/research.png": "9ab38d26112f1762ced92d838e21258d",
"assets/assets/images/sandglass.png": "2f689feb938ca7b4ab488faeb4ea9835",
"assets/assets/images/search.jpg": "fd2c6fdfd08940dcef409d3b75064a96",
"assets/assets/images/send.jpg": "3adad9e6e72f789699ac001078ecc3c1",
"assets/assets/images/signUp.jpg": "1811f344025539b7b4abb446eb6f910d",
"assets/assets/images/speech-bubble.png": "2bfd39df0d6605379b460d08e046e525",
"assets/assets/images/stopwatch.png": "5a6a3c22ddedbb50cd6f64372fe2d588",
"assets/assets/images/survey.png": "a9c4feebb40ddb1894f4778ef542d901",
"assets/assets/images/telephone.png": "e32444726264e197038d4e56a63758f1",
"assets/assets/images/Twitter.png": "dfcf7fda35e6aa2d99184f54565e7a88",
"assets/assets/images/web.png": "b4bde176e0025f819e124dabd7f822f1",
"assets/assets/images/welcome.jpg": "b03985729537f0c5f96605bdc1d081ae",
"assets/assets/images/women.png": "082bad33f7d8cc39912e24ab632de6f3",
"assets/assets/images/Youtube.png": "d0c35307ad3c2d2957f5f77704ce3ba4",
"assets/assets/images/Zoom.us.png": "f47150bfaca6692cd803dbc469f34f23",
"assets/FontManifest.json": "5ce07202ed923c0749512db469983268",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/NOTICES": "1ec7bd77f6b50ac7c28bce0a24886367",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "e7006a0a033d834ef9414d48db3be6fc",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "00bb2b684be61e89d1bc7d75dee30b58",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "4b6a9b7c20913279a3ad3dd9c96e155b",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "dffd9504fcb1894620fa41c700172994",
"assets/packages/line_awesome_flutter/lib/fonts/LineAwesome.ttf": "bcc78af7963d22efd760444145073cd3",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "88a73e0c5a5f268aff5b655691a1e4b6",
"/": "88a73e0c5a5f268aff5b655691a1e4b6",
"main.dart.js": "15ffa58c3e69bfdd05e11570d174a58b",
"manifest.json": "e1dab266946399c15843140c5f7a734b",
"version.json": "c40ff30de60b3edd5fd111b83f3b3cf0"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
