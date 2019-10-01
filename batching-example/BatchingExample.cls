global class BatchingExample {
    public static void truncateObjects() {
        List<Object_Type_1__c> list1 = [SELECT Id FROM Object_Type_1__c];
        List<Object_Type_2__c> list2 = [SELECT Id FROM Object_Type_2__c];

        if (list1.size() + list2.size() > 10000) {
            List<sObject> allItems = new List<sObject>();

            allItems.addAll(list1);
            allItems.addAll(list2);
            
            batchDelete(allItems);
        } else {
            delete list1;
            delete list2;
        }
    }
    
    private static void batchDelete(List<sObject> items) {
        if (items.size() > 1000) {
            List<sObject> batchToDelete = new List<sObject>();
            List<sObject> nextBatch = new List<sObject>();

            for (sObject item : items) {
                if (batchToDelete.size() < 1000) {
                    batchToDelete.add(item);
                } else {
                    nextBatch.add(item);
                }
            }

            deleteAsync(Json.serialize(batchToDelete));

            batchDelete(nextBatch);
        } else {
            delete items;
        }
    }

    @future
    private static void deleteAsync(string serializedItems) {
        List<sObject> items = ((List<sObject>)Json.deserialize(serializedItems, List<sObject>.class));
        items.sort();

        delete items;
    }
}