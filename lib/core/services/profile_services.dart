import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:logger/logger.dart';
import 'package:real_estate_app/core/constants/api_endpoints.dart';
import 'package:real_estate_app/core/errors/failure.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:real_estate_app/core/networks/exceptions/api_exceptions.dart';
import 'package:real_estate_app/core/networks/exceptions/exceptions.dart';
import 'package:real_estate_app/core/utils/typedef.dart';
import 'package:real_estate_app/features/profile/models/basic_info_update_model.dart';

class ProfileServices {
  final Logger log = Logger();
  final dio = Get.find<DioHelper>();

  FutureResult<String?> updateAvatar(File image) async {
    try {
      final formData = FormData.fromMap({
        "profile_image": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      final response = await dio.request(
        ApiRequest(
          url: ApiEndpoints.uploadAvatar,
          method: ApiMethod.post,
          body: formData,
        ),
      );

      return Right(response.data['data']["profile_url"]);
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }

  FutureResult<BasicInfoUpdateModel> updateBasicInfo(
    BasicInfoUpdateModel req,
  ) async {
    final data = {
      if (req.fullName.isNotEmpty) 'full_name': req.fullName,
      if (req.email.isNotEmpty) 'email': req.email,
      if (req.phone.isNotEmpty) 'phone': req.phone,
    };
    try {
      final res = await dio.request(
        ApiRequest(
          url: ApiEndpoints.updateBasicInfo,
          method: ApiMethod.put,
          body: data,
        ),
      );
      log.d(res.data);
      final response = res.data["data"] as Map<String, dynamic>;
      return Right(BasicInfoUpdateModel.fromJson(response));
    } on AppException catch (e) {
      return Left(ApiException.map(e));
    } catch (e) {
      return Left(Failure(message: e.toString(), type: FailureType.network));
    }
  }
}
