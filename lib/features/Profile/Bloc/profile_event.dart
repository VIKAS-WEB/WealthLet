import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfilePicture extends ProfileEvent {}

class UploadProfilePicture extends ProfileEvent {
  final String imagePath;

  const UploadProfilePicture({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

class ProfilePictureLoadFailed extends ProfileEvent {}

class UpdatePhoneNumber extends ProfileEvent {
  final String phoneNumber;

  const UpdatePhoneNumber({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class UpdateEmail extends ProfileEvent {
  final String email;

  const UpdateEmail({required this.email});

  @override
  List<Object?> get props => [email];
}

class UpdateAddress extends ProfileEvent {
  final String address;

  const UpdateAddress({required this.address});

  @override
  List<Object?> get props => [address];
}