import 'package:fixmate/model/populerservice_mdel.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:flutter/material.dart';

class Populerservicedata {
  final List<PopulerserviceMdel> populerservice = [
    PopulerserviceMdel(
      title: 'Painting',
      image: 'assets/icons/paint.svg',
      color: AppColors.painter,
    ),
    PopulerserviceMdel(
      title: 'Plumbing',
      image: 'assets/icons/plumb.svg',
      color: AppColors.plumber,
    ),
    PopulerserviceMdel(
      title: 'Electrical',
      image: 'assets/icons/light.svg',
      color: AppColors.electrician,
    ),
    PopulerserviceMdel(
      title: 'Carpentry',
      image: 'assets/icons/saw.svg',
      color: AppColors.carpenter,
    ),
    PopulerserviceMdel(
      title: 'AC Repair',
      image: 'assets/icons/air.svg',
      color: AppColors.acRepair,
    ),
    PopulerserviceMdel(
      title: 'Masonry',
      image: 'assets/icons/wall.svg',
      color: AppColors.masonry,
    ),
    PopulerserviceMdel(
      title: 'CCTV Repair',
      image: 'assets/icons/cctv.svg',
      color: AppColors.cctv,
    ),
    PopulerserviceMdel(
      title: 'Cleaning',
      image: 'assets/icons/mop.svg',
      color: AppColors.cleaning,
    ),
  ];
}
