Codeunit 50001 ProcessShipment
{
    trigger OnRun();
    var
        HttpClinet: HttpClient;
        ResponseMessag: HttpResponseMessage;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonArray: JsonArray;
        JsonObject: JsonObject;
        consumerKey: Text;
        consumerSecret: Text;
        accessToken: Text;
        accessSecret: Text;
        url: Text;
        endpoint: Text;
        request: Text;
        content: HttpContent;
        responseText: Text;
    begin
        consumerKey := 'fc5d2e831b5df9aef116c51bb39aaf83';
        consumerSecret := '39250ee648c18636efe54557cf636db0';
        accessToken := '8066463c407d38bc4c10fddf9424ad5e';
        accessSecret := 'b619bfeddb908552cff2403727887934';
        url := 'https://sandbox.goldenscent.com/api/rest/';
        endpoint := 'shipments';
        request := '{"increment_id":"200443116","carrier":"smsa","items_qty":["SA1677203-1"]}';
        content.WriteFrom(request);

        HttpClinet.Post(url + endpoint + '?oauth_consumer_key=' + consumerKey + '&oauth_token=' + accessToken
                    + '&oauth_signature_method=PLAINTEXT&oauth_signature=' + consumerSecret +
                    '%26' + accessSecret, content, ResponseMessag);
        ResponseMessag.Content.ReadAs(responseText);
        Message(responseText);
    end;


}
