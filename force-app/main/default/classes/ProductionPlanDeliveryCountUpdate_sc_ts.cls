/**
 * Created by ms on 2020-05-06.
 */

@IsTest
private class ProductionPlanDeliveryCountUpdate_sc_ts {
    @IsTest
    static void testBehavior() {
        ProductionPlanDeliveryCountUpdate_sc.runSchedule();
        ProductionPlanDeliveryCountUpdate_sc.abortSchedule();
        ProductionPlanDeliveryCountUpdate_sc.excuteBatch();
    }
}