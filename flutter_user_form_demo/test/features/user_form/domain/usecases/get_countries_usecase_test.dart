import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_user_form_demo/core/errors/failures.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/entities/country.dart';
import 'package:flutter_user_form_demo/features/user_form/domain/usecases/get_countries_usecase.dart';

import '../../../../helpers/test_mocks.dart';

void main() {
  late GetCountriesUseCase useCase;
  late SearchCountriesUseCase searchUseCase;
  late MockLocationRepository mockLocationRepository;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    useCase = GetCountriesUseCase(mockLocationRepository);
    searchUseCase = SearchCountriesUseCase(mockLocationRepository);
  });

  group('GetCountriesUseCase', () {
    final tCountries = [
      const Country(id: '1', name: 'Colombia', code: 'CO', isActive: true),
      const Country(id: '2', name: 'Venezuela', code: 'VE', isActive: true),
      const Country(id: '3', name: 'Ecuador', code: 'EC', isActive: false),
    ];

    test('should get active countries sorted by name', () async {
      when(mockLocationRepository.getCountries())
          .thenAnswer((_) async => Right(tCountries));

      final result = await useCase();

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Should return success'),
        (countries) {
          expect(countries.length, equals(2));
          expect(countries.every((c) => c.isActive), isTrue);
          expect(countries[0].name, equals('Colombia'));
          expect(countries[1].name, equals('Venezuela'));
        },
      );
      verify(mockLocationRepository.getCountries());
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should return empty list when no active countries exist', () async {
      final inactiveCountries = [
        const Country(id: '1', name: 'Country 1', code: 'C1', isActive: false),
        const Country(id: '2', name: 'Country 2', code: 'C2', isActive: false),
      ];

      when(mockLocationRepository.getCountries())
          .thenAnswer((_) async => Right(inactiveCountries));

      final result = await useCase();

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Should return success'),
        (countries) {
          expect(countries, isEmpty);
        },
      );
      verify(mockLocationRepository.getCountries());
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      const tServerFailure = ServerFailure(
        message: 'Server error',
        code: 'SERVER_ERROR',
      );

      when(mockLocationRepository.getCountries())
          .thenAnswer((_) async => const Left(tServerFailure));

      final result = await useCase();

      expect(result, equals(const Left(tServerFailure)));
      verify(mockLocationRepository.getCountries());
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should return NetworkFailure when network error occurs', () async {
      const tNetworkFailure = NetworkFailure(
        message: 'No internet connection',
        code: 'NETWORK_ERROR',
      );

      when(mockLocationRepository.getCountries())
          .thenAnswer((_) async => const Left(tNetworkFailure));

      final result = await useCase();

      expect(result, equals(const Left(tNetworkFailure)));
      verify(mockLocationRepository.getCountries());
      verifyNoMoreInteractions(mockLocationRepository);
    });
  });

  group('SearchCountriesUseCase', () {
    const tQuery = 'Colombia';
    const tParams = SearchCountriesParams(query: tQuery);

    final tCountries = [
      const Country(id: '1', name: 'Colombia', code: 'CO', isActive: true),
      const Country(
          id: '2', name: 'British Columbia', code: 'BC', isActive: true),
      const Country(
          id: '3', name: 'District of Columbia', code: 'DC', isActive: false),
    ];

    test('should search countries successfully and return sorted results',
        () async {
      when(mockLocationRepository.searchCountries(tQuery))
          .thenAnswer((_) async => Right(tCountries));

      final result = await searchUseCase(tParams);

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Should return success'),
        (countries) {
          expect(countries.length, equals(2));
          expect(countries.every((c) => c.isActive), isTrue);
          expect(countries[0].name, equals('Colombia'));
          expect(countries[1].name, equals('British Columbia'));
        },
      );
      verify(mockLocationRepository.searchCountries(tQuery));
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should return ValidationFailure when query is empty', () async {
      const emptyParams = SearchCountriesParams(query: '');

      final result = await searchUseCase(emptyParams);

      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, equals('Search query cannot be empty'));
          expect(failure.code, equals('EMPTY_SEARCH_QUERY'));
        },
        (countries) => fail('Should return failure'),
      );
      verifyZeroInteractions(mockLocationRepository);
    });

    test('should return ValidationFailure when query is too short', () async {
      const shortParams = SearchCountriesParams(query: 'A');

      final result = await searchUseCase(shortParams);

      expect(result, isA<Left>());
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message,
              equals('Search query must be at least 2 characters long'));
          expect(failure.code, equals('SHORT_SEARCH_QUERY'));
        },
        (countries) => fail('Should return failure'),
      );
      verifyZeroInteractions(mockLocationRepository);
    });

    test('should return empty list when no active matching countries exist',
        () async {
      final inactiveCountries = [
        const Country(id: '1', name: 'Colombia', code: 'CO', isActive: false),
      ];

      when(mockLocationRepository.searchCountries(tQuery))
          .thenAnswer((_) async => Right(inactiveCountries));

      final result = await searchUseCase(tParams);

      expect(result, isA<Right>());
      result.fold(
        (failure) => fail('Should return success'),
        (countries) {
          expect(countries, isEmpty);
        },
      );
      verify(mockLocationRepository.searchCountries(tQuery));
      verifyNoMoreInteractions(mockLocationRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      const tServerFailure = ServerFailure(
        message: 'Server error',
        code: 'SERVER_ERROR',
      );

      when(mockLocationRepository.searchCountries(tQuery))
          .thenAnswer((_) async => const Left(tServerFailure));

      final result = await searchUseCase(tParams);

      expect(result, equals(const Left(tServerFailure)));
      verify(mockLocationRepository.searchCountries(tQuery));
      verifyNoMoreInteractions(mockLocationRepository);
    });
  });

  group('SearchCountriesParams', () {
    const tQuery = 'Colombia';

    test('should be a subclass of UseCaseParams', () {
      const params = SearchCountriesParams(query: tQuery);

      expect(params, isA<SearchCountriesParams>());
    });

    test('should return correct props for equality comparison', () {
      const params1 = SearchCountriesParams(query: tQuery);
      const params2 = SearchCountriesParams(query: tQuery);

      expect(params1, equals(params2));
      expect(params1.props, equals([tQuery]));
    });

    test('should not be equal when queries differ', () {
      const params1 = SearchCountriesParams(query: 'Colombia');
      const params2 = SearchCountriesParams(query: 'Venezuela');

      expect(params1, isNot(equals(params2)));
    });
  });
}
