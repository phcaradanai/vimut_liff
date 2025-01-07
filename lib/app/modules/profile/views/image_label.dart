part of 'profile_view.dart';

class ImageLabel extends GetView<ProfileController> {
  const ImageLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: Get.textTheme.titleMedium?.fontSize,
                  overflow: TextOverflow.ellipsis,
                ).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  await controller.logout();
                  Get.offAllNamed('/sign-in');
                },
                icon: const Icon(
                  Icons.logout,
                ),
                style: const ButtonStyle(
                  enableFeedback: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 1,
        ),
        Stack(
          children: [
            Obx(
              () => SizedBox(
                height: 110,
                width: 110,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: controller.findUserPic(controller.profile),
                ),
              ),
            ),
            Positioned(
              right: -6,
              bottom: -3,
              child: IconButton(
                onPressed: () async {
                  final XFile? file = await controller.picker.pickImage(
                      maxHeight: 100,
                      maxWidth: 100,
                      source: ImageSource.gallery);
                  await controller.fetchUploadImageProfile(file);
                },
                icon: const Icon(Icons.edit_square),
                style: const ButtonStyle(
                  enableFeedback: true,
                ),
              ),
            )
          ],
        ),
        Obx(
          () => Text(
            controller.profile['displayName'],
            style: TextStyle(
              fontSize: Get.textTheme.labelMedium?.fontSize,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
