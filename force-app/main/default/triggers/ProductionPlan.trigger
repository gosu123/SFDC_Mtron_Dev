/**
 * Created by i2max-KichangHeo on 2022-07-08.
 */

trigger ProductionPlan on ProductionPlan__c (before insert, before update) {
    new ProductionPlan_tr().run();
}