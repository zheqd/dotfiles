function cbc-aps-token() {
kubectl exec -t oss-node-0 -c core-ear -- python -c """from poaupdater import openapi, uLogging;
uLogging.debug = uLogging.log_func(None, None);
open_api = openapi.OpenAPI()
aps_token = open_api.pem.APS.getUserToken(user_id=${1-1})['aps_token']
print aps_token"""
}

function cbc-plm-app-instance() {
kubectl exec -ti oss-node-0 -c core-ear -- curl -E /usr/local/pem/APS/certificates/poa.pem -k -X GET 'https://localhost:6308/aps/2/resources?implementing(http://com.odin.platform/inhouse-products/application/1.0)' | jq -r '.[0].aps.id'
}

function cbc-plm-business-metrics() {
PLM_APP_INSTANCE=$(plm-app-instance 2>&1)
BUSINESS_METRICS_URL="https://localhost:6308/aps/2/resources/$PLM_APP_INSTANCE/business-metrics"
kubectl exec -ti oss-node-0 -c core-ear -- bash -c "curl -E /usr/local/pem/APS/certificates/poa.pem -k -X GET $BUSINESS_METRICS_URL | python -m json.tool"
}

function cbc-subscription-vendor-parameters() {
kubectl exec -t oss-node-0 -c core-ear -- python -c """from poaupdater import openapi, uLogging
uLogging.debug = uLogging.log_func(None, None);
open_api = openapi.OpenAPI()
print open_api.pem.getSubscriptionVendorParameters(subscription_id=$1)"""
}
