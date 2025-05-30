import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';
import 'package:wealthlet/features/Profile/Bloc/profile_bloc.dart';
import 'package:wealthlet/features/Profile/Bloc/profile_event.dart';
import 'package:wealthlet/features/Profile/Bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  final picker = ImagePicker();

  ProfilePage({super.key});

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      context.read<ProfileBloc>().add(UploadProfilePicture(imagePath: pickedFile.path));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  }

  void _showPhoneNumberEditDialog(BuildContext blocContext, String? currentPhone) {
    final phoneController = TextEditingController(text: currentPhone ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: blocContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Phone Number'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number (e.g., +917017174051)',
                prefixIcon: Icon(Icons.phone),
                hintText: '+91xxxxxxxxxx',
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a phone number';
                }
                if (!RegExp(r'^\+\d{1,3}\d{6,14}$').hasMatch(value)) {
                  return 'Please enter a valid phone number with country code (e.g., +917017174051)';
                }
                return null;
              },
              onChanged: (value) {
                if (!value.startsWith('+')) {
                  phoneController.text = '+91$value';
                  phoneController.selection = TextSelection.fromPosition(
                    TextPosition(offset: phoneController.text.length),
                  );
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  blocContext.read<ProfileBloc>().add(
                        UpdatePhoneNumber(
                          phoneNumber: phoneController.text.trim(),
                        ),
                      );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEmailEditDialog(BuildContext blocContext, String? currentEmail) {
    final emailController = TextEditingController(text: currentEmail ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: blocContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Email'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  blocContext.read<ProfileBloc>().add(
                        UpdateEmail(
                          email: emailController.text.trim(),
                        ),
                      );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddressEditDialog(BuildContext blocContext, String? currentAddress) {
    final addressController = TextEditingController(text: currentAddress ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: blocContext,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Address'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.home),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an address';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  blocContext.read<ProfileBloc>().add(
                        UpdateAddress(
                          address: addressController.text.trim(),
                        ),
                      );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfilePicture()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          } else if (state is ProfilePictureLoaded) {
            final previousState = context.read<ProfileBloc>().state;
            if (previousState is ProfilePictureLoaded) {
              if (previousState.profilePicUrl != state.profilePicUrl && state.profilePicUrl != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile picture uploaded successfully'), backgroundColor: ColorsField.savingsGreen,),
                );
              } else if (previousState.phoneNumber != state.phoneNumber && state.phoneNumber != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Phone number updated successfully'), backgroundColor: ColorsField.savingsGreen, ),
                );
                context.read<ProfileBloc>().add(LoadProfilePicture());
              } else if (previousState.address != state.address && state.address != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Address updated successfully'), backgroundColor: ColorsField.savingsGreen,),
                );
                context.read<ProfileBloc>().add(LoadProfilePicture());
              } else if (previousState.email != state.email && state.email != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email updated successfully'), backgroundColor: ColorsField.savingsGreen,),
                );
                context.read<ProfileBloc>().add(LoadProfilePicture());
              }
            }
          }
        },
        builder: (context, state) {
          String? profilePicUrl;
          bool isImageLoading = false;
          String? name;
          String? email;
          String? phoneNumber;
          String? address;

          if (state is ProfilePictureLoaded) {
            profilePicUrl = state.profilePicUrl;
            isImageLoading = state.isImageLoading;
            name = state.name;
            email = state.email;
            phoneNumber = state.phoneNumber;
            address = state.address;
          } else if (state is ProfileLoading) {
            isImageLoading = true;
            name = 'Loading...';
            email = 'Loading...';
            phoneNumber = 'Not set';
            address = 'Not set';
          } else {
            name = 'Error';
            email = 'Error';
            phoneNumber = 'Not set';
            address = 'Not set';
          }

          return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: ColorsField.backgroundLight,)),
              title: const Text('Profile', style: TextStyle(color: ColorsField.backgroundLight),),
              centerTitle: true,
              elevation: 0,
              backgroundColor: ColorsField.buttonRed,
              foregroundColor: Colors.black,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      profilePicUrl != null
                          ? CachedNetworkImage(
                              imageUrl: profilePicUrl,
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                radius: 50,
                                backgroundImage: imageProvider,
                                backgroundColor: Colors.grey[300],
                              ),
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[300],
                                ),
                              ),
                              errorWidget: (context, url, error) {
                                context.read<ProfileBloc>().add(ProfilePictureLoadFailed());
                                return CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[300],
                                  child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                                );
                              },
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                            ),
                      if (isImageLoading && profilePicUrl == null)
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _pickAndUploadImage(context),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey[300]!, width: 2),
                            ),
                            child: const Icon(Icons.edit, size: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: state is ProfileLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.person_outline, color: Colors.grey[600]),
                                    title: Container(
                                      width: double.infinity,
                                      height: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.email_outlined, color: Colors.grey[600]),
                                    title: Container(
                                      width: double.infinity,
                                      height: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.phone_outlined, color: Colors.grey[600]),
                                    title: Container(
                                      width: double.infinity,
                                      height: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.home_outlined, color: Colors.grey[600]),
                                    title: Container(
                                      width: double.infinity,
                                      height: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.person_outline),
                                  title: Text(name ?? 'Loading...'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.email_outlined),
                                  title: Text(email ?? 'Loading...'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showEmailEditDialog(context, email),
                                  ),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.phone_outlined),
                                  title: Text(phoneNumber ?? 'Not set'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showPhoneNumberEditDialog(context, phoneNumber),
                                  ),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.home_outlined),
                                  title: Text(address ?? 'Not set'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showAddressEditDialog(context, address),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}