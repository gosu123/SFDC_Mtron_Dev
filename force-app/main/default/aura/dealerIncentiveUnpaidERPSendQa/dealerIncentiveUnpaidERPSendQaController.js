({
    /**
     * 초기 거래
     * @param component
     * @param event
     * @param helper
     */
    doInit: function (component, event, helper) {
        helper.apex(
            component, 'doInit', 'init', {'recordId':component.get('v.recordId')}
        ).then(function ({resData, response}) {
            component.set('v.dii', resData);
            component.set('v.isSend', resData.IsSend__c);
        }).catch(function ({error, response}) {
            helper.gfn_ApexErrorHandle(error, response);
        });
    },

    /**
     * 판매장려 기표 - 미지급건 전송 처리
     * @param component
     * @param event
     * @param helper
     */
    doSend: function (component, event, helper) {
        helper.apex(
            component, 'doSend', 'sendERP', {'recordId' : component.get('v.recordId')}
        ).then(({resData, response}) => {
            helper.gfn_toast('판매장려 기표 미지급건 전송 처리 하였습니다.', 's');
            helper.gfn_closeQuickActionModal(component);
            helper.gfn_refresh();
        }).catch((error) => {
            helper.gfn_ApexErrorHandle(error);
        });
    },


    /**
     * 판매장려 기표 - 미지급건 취소 처리
     * @param component
     * @param event
     * @param helper
     */
    doSendCancel: function (component, event, helper) {
        helper.apex(
            component, 'doSendCancel', 'sendERPCancel', {'recordId' : component.get('v.recordId')}
        ).then(({resData, response}) => {
            helper.gfn_toast('판매장려 기표 미지급건 취소 처리 하였습니다.', 's');
            helper.gfn_closeQuickActionModal(component);
            helper.gfn_refresh();
        }).catch((error) => {
            helper.gfn_ApexErrorHandle(error);
        });
    },

});