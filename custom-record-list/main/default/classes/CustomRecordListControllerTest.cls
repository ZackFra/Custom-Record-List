@IsTest
public with sharing class CustomRecordListControllerTest {
  final static Integer EXPECTED_PAGE_SIZE = CustomRecordListService.PAGE_SIZE;

  private static GetRecordOptions buildOptions(List<String> fields) {
    GetRecordOptions options = new GetRecordOptions();
    options.fields = fields;
    options.objectName = 'Group';
    options.nameField = 'Name';
    options.searchKey = 'Name';
    return options;
  }

  private static GetRecordOptions buildOptions() {
    return buildOptions(null);
  }

  // suppressed warning, the assert is in the UniversalMocker class
  @IsTest
  @SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
  private static void testGetRecords() {
    Group g1 = new Group(
      Name = 'Test Group 1',
      DeveloperName = 'Test_Group_1',
      Type = 'Regular',
      Id = fflib_IDGenerator.generate(Group.SObjectType)
    );

    Group g2 = new Group(
      Name = 'Test Group 2',
      DeveloperName = 'Test_Group_2',
      Type = 'Regular',
      Id = fflib_IDGenerator.generate(Group.SObjectType)
    );

    List<Group> groups = new List<Group>{ g1, g2 };

    UniversalMocker mockInstance = UniversalMocker.mock(
      CustomRecordListService.class
    );
    mockInstance.when('getRecords').thenReturn(groups);
    CustomRecordListService mockService = (CustomRecordListService) mockInstance.createStub();

    CustomRecordListController.service = mockService;

    List<String> fields = new List<String>{ 'Name', 'DeveloperName', 'Type' };
    GetRecordOptions options = buildOptions(fields);
    Test.startTest();
    CustomRecordListController.getRecords(options, 0);
    Test.stopTest();
    mockInstance.assertThat().method('getRecords').wasCalled(1);
  }

  @IsTest
  private static void testGetRecordsFail() {
    UniversalMocker mockInstance = UniversalMocker.mock(
      CustomRecordListService.class
    );
    mockInstance.when('getRecords')
      .thenThrow(new QueryException('Test Exception'));
    CustomRecordListService mockService = (CustomRecordListService) mockInstance.createStub();

    CustomRecordListController.service = mockService;

    List<String> fields = new List<String>{ 'Name', 'DeveloperName', 'Type' };
    Boolean isAuraHandled = false;
    GetRecordOptions options = buildOptions(fields);
    Test.startTest();
    try {
      CustomRecordListController.getRecords(options, 0);
    } catch (AuraHandledException e) {
      isAuraHandled = true;
    } catch (Exception e) {
      isAuraHandled = false;
    }
    Test.stopTest();
    Assert.isTrue(
      isAuraHandled,
      'Exception was not handled by AuraHandledException'
    );
  }

  // suppressed warning, the assert is in the UniversalMocker class

  @IsTest
  @SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
  private static void testGetRecordCount() {
    UniversalMocker mockInstance = UniversalMocker.mock(
      CustomRecordListService.class
    );
    mockInstance.when('getRecordCount').thenReturn(2);
    CustomRecordListService mockService = (CustomRecordListService) mockInstance.createStub();

    CustomRecordListController.service = mockService;
    GetRecordOptions options = buildOptions();

    Test.startTest();
    CustomRecordListController.getRecordCount(options);
    Test.stopTest();
    mockInstance.assertThat().method('getRecordCount').wasCalled(1);
  }

  @IsTest
  private static void testGetRecordCountFail() {
    UniversalMocker mockInstance = UniversalMocker.mock(
      CustomRecordListService.class
    );
    mockInstance.when('getRecordCount')
      .thenThrow(new QueryException('Test Exception'));
    CustomRecordListService mockService = (CustomRecordListService) mockInstance.createStub();

    CustomRecordListController.service = mockService;
    GetRecordOptions options = buildOptions();
    Boolean isAuraHandled = false;
    Test.startTest();
    try {
      CustomRecordListController.getRecordCount(options);
    } catch (AuraHandledException e) {
      isAuraHandled = true;
    } catch (Exception e) {
      isAuraHandled = false;
    }
    Test.stopTest();
    Assert.isTrue(
      isAuraHandled,
      'Exception was not handled by AuraHandledException'
    );
  }

  @IsTest
  private static void testGetPageSize() {
    Test.startTest();
    Integer pageSize = CustomRecordListController.getPageSize();
    Test.stopTest();

    Assert.areEqual(
      EXPECTED_PAGE_SIZE,
      pageSize,
      'Page size is not as expected'
    );
  }
}
