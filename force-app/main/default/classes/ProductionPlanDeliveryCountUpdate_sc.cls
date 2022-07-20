/****************************************************************************************
  * @filename      : ProductionPlanDeliveryCountUpdate_sc
  * @author        : I2MAX
  * @date          : 2022-07-15
  * @group         :
  * @group-content :
  * @description   :
  * @tester        : ProductionPlanDeliveryCountUpdate_sc_ts.cls
  * @schedule      :
  * @reference     :
  * @copyright     : Copyright © I2max. All Rights Reserved.
  * @modification Log
  * ===============================================================
  * ver     date             author        description
  * ===============================================================
    1.0     2022-07-15       I2MAX         Create (ITVOC-2022-06-0861)
****************************************************************************************/


public with sharing class ProductionPlanDeliveryCountUpdate_sc implements Schedulable {

    // Schedule 등록 배치명
    private static String batchName = '생산계획-출하건수업데이트_2시30분';
    // Schedule Cron Expression (매일 새벽 3시)
    private static String batchCron = '0 30 2 ? * * *';
    // Batch 수행 Size
    private static Integer batchSize = 1;

    /**
     * 배치 실행 멤버 함수
     *
     * @param SC : SchedulableContext
     */
    public void execute(SchedulableContext SC) {
        ProductionPlanDeliveryCountUpdate_sc.excuteBatch();
    }

    /**
     * 배치 Schedule 등록
     * ProductionPlanDeliveryCountUpdate_sc.runSchedule();
     */
    public static void runSchedule() {
        System.schedule(batchName, batchCron, new ProductionPlanDeliveryCountUpdate_sc());
    }

    /**
     *  배치 Schedule 삭제
     *  ProductionPlanDeliveryCountUpdate_sc.abortSchedule();
     */
    public static void abortSchedule() {
        for (CronTrigger t : [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = :batchName]) {
            if(!Test.isRunningTest())   System.abortJob(t.Id);
        }
    }

    /**
     * 배치 실행(외부 바로 호출)
     * ProductionPlanDeliveryCountUpdate_sc.excuteBatch();
     */
    public static void excuteBatch() {
        Database.executeBatch(new ProductionPlanDeliveryCountUpdate_ba(), batchSize);
    }


}