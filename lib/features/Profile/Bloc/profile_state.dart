import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfilePictureLoaded extends ProfileState {
  final String? profilePicUrl;
  final bool isImageLoading;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? address;

  const ProfilePictureLoaded({
    this.profilePicUrl,
    required this.isImageLoading,
    this.name,
    this.email,
    this.phoneNumber,
    this.address,
  });

  @override
  List<Object?> get props => [profilePicUrl, isImageLoading, name, email, phoneNumber, address];
}

class ProfileError extends ProfileState {
  final String errorMessage;

  const ProfileError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}