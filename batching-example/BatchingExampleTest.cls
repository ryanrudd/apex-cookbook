@isTest
public class BatchingExampleTest {
    @isTest
    static void truncateObjects_Empty() {
        Test.startTest();

        BatchingExample.truncateObjects();

        Test.stopTest();

        System.assertEquals(true, allEmpty());
    }

    @isTest
    static void truncateObjects_All() {
        Object_Type_1__c object1 = new Object_Type_1__c();
        insert object1;

        Object_Type_2__c object1 = new Object_Type_2__c();
        insert object2;

        Test.startTest();

        BatchingExample.truncateObjects();

        Test.stopTest();

        System.assertEquals(true, allEmpty());
    }

    @isTest
    static void truncateObjects_WithBatches() {
        Object_Type_1__c object1 = new Object_Type_1__c();
        insert object1;

        List<Object_Type_2__c> object2list = new List<Object_Type_2__c>();
        for (integer i = 0; i < 9000; i++) {
            Object_Type_2__c object2 = new Object_Type_2__c();

            object2list.add(object2);
        }
        
        insert object2list;

        Test.startTest();

        object2list = new List<Object_Type_2__c>();
        for (integer i = 0; i < 2000; i++) {
            Object_Type_2__c object2 = new Object_Type_2__c();

            object2list.add(object2);
        }

        insert object2list;

        BatchingExample.truncateObjects();

        Test.stopTest();

        System.assertEquals(true, allEmpty());
    }

    private static boolean object1IsEmpty() { 
        return [Select Id from Object_Type_1__c].size() == 0;
    }

    private static boolean object2IsEmpty() {
        return [Select Id from Object_Type_2__c ].size() == 0;
    }

    private static boolean allEmpty() {
        return object1IsEmpty() && object2IsEmpty();
    }
}