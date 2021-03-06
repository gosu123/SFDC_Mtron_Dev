/****************************************************************************************
 * @filename      : TransferApprovalQaHelper.js
 * @projectname   :
 * @author        : SEOKHO LEE
 * @date          : 2020-11-24 오후 12:41
 * @group         :
 * @group-content :
 * @description   :
 * @tester        :
 * @reference     :
 * @copyright     : Copyright © I2max. All Rights Reserved.
 * @modification Log
 * ===============================================================
 * ver     date                     author              description
 * ===============================================================
 0.1     2020-11-24 오후 12:41      SEOKHO LEE          Create
 ****************************************************************************************/

({
    fn_checkValid: function (component) {
        console.log('fn_checkValid ------------------');

        let isRejectGrant = component.get('v.isRejectGrant');
        let isTargetContract = component.get('v.isTargetContract');
        let isSendReceiveItem = component.get('v.isSendReceiveItem');
        let notiMessage = component.get('v.notiMessage');

        if(isRejectGrant) {
            // 거부 가능.
            if(isSendReceiveItem) {
                if(isTargetContract) {
                    const resultList = this.gfn_getInputCheckedList(component.find('check'));
                    if (resultList.length === 0) {
                        this.gfn_toast('계약은 반드시 선택 해야 합니다.', 'w');
                        return false;
                    }
                } else {
                    this.gfn_toast('고객 인도를 준비중인 계약건이 없습니다. 승인 처리 진행 해주세요.', 'w');
                    return false;
                }
            }
        }
        return true;
    }
});