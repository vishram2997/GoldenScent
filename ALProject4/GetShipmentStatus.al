Codeunit 50001 ProcessShipment
{
    trigger OnRun();
    var

    begin

    end;

    local procedure UpdateShipmentTracking()
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonArray: JsonArray;
        trackingLine: JsonToken;
        entity_id: JsonToken;
        increment_id: JsonToken;
        parent_id: JsonToken;
        order_id: JsonToken;
        track_number: JsonToken;
        carrier_code: JsonToken;
        label_url: JsonToken;
        JsonResponse: JsonObject;
        request: Text;
        whsShipment: Record "Warehouse Shipment Header";
        awbIntegration: Record AWBIntegration;
        responseSample: Text;
        i: Integer;
        whsShipmentLine: Record "Warehouse Shipment Line";
        itemsInShipment: Text;
        carrier: Text;
    begin

        whsShipment.Reset();
        whsShipment.SetRange("Completely Picked", true);
        if whsShipment.FindSet then
            repeat
                if whsShipment."Location Code" = 'DXB' then
                    carrier := 'Aramex'
                else
                    carrier := 'smsa';

                awbIntegration.Reset;
                awbIntegration.SetRange(whsShipmentNo, whsShipment."No.");
                if not awbIntegration.FindFirst then begin
                    whsShipmentLine.Reset();
                    whsShipmentLine.SetRange("No.", whsShipment."No.");
                    if whsShipmentLine.FindFirst() then
                        repeat
                            itemsInShipment := itemsInShipment + '-' + Format(whsShipmentLine."Qty. (Base)") + ';';
                        until whsShipmentLine.Next() = 0;
                    request := '{"increment_id":"' + format(whsShipment."No.") + '","carrier":"' + carrier + '","items_qty":["' + itemsInShipment + '"]}';
                    responseSample := getHttpResponse('https://sandbox.goldenscent.com/api/rest/', 'shipment', request);
                    JsonResponse.ReadFrom(responseSample);
                    //JsonToken.ReadFrom(responseText);
                    //JsonToken.SelectToken('increment_id', JsonToken);

                    //parsing json response
                    JsonResponse.SelectToken('_shipment_tracks', JsonToken);
                    JsonArray := JsonToken.AsArray();
                    JsonResponse.SelectToken('increment_id', increment_id);
                    for i := 0 to JsonArray.Count - 1 do begin
                        JsonArray.Get(i, trackingLine);
                        JsonResponse := trackingLine.AsObject();
                        JsonResponse.Get('entity_id', entity_id);
                        JsonResponse.Get('parent_id', parent_id);
                        JsonResponse.Get('order_id', order_id);
                        JsonResponse.Get('track_number', track_number);
                        JsonResponse.Get('carrier_code', carrier_code);
                        JsonResponse.Get('label_url', label_url);

                        //insert into awbIntegration
                        awbIntegration.Init();
                        awbIntegration.increment_id := increment_id.AsValue().AsText();
                        awbIntegration.whsShipmentNo := whsShipment."No.";
                        awbIntegration.entity_id := entity_id.AsValue().AsText();
                        awbIntegration.order_id := order_id.AsValue().AsText();
                        awbIntegration.parent_id := parent_id.AsValue().AsText();
                        awbIntegration.track_number := track_number.AsValue().AsText();
                        awbIntegration.carrier_code := carrier_code.AsValue().AsText();
                        awbIntegration.label_url := label_url.AsValue().AsText();
                        awbIntegration.Insert()
                    end;  //for end

                end;
            until whsShipment.Next = 0;

    end;

    local procedure getHttpResponse(url: Text; endpoint: Text; request: Text): Text
    var
        consumerKey: Text;
        consumerSecret: Text;
        accessToken: Text;
        accessSecret: Text;
        content: HttpContent;
        responseText: Text;
        HttpClinet: HttpClient;
        ResponseMessag: HttpResponseMessage;
    begin
        consumerKey := 'fc5d2e831b5df9aef116c51bb39aaf83';
        consumerSecret := '39250ee648c18636efe54557cf636db0';
        accessToken := '8066463c407d38bc4c10fddf9424ad5e';
        accessSecret := 'b619bfeddb908552cff2403727887934';
        url := 'https://sandbox.goldenscent.com/api/rest/';
        endpoint := 'shipments';
        request := '{"increment_id":"200443116","carrier":"smsa","items_qty":["SA1677203-1"]}';

        //whsShipment.Reset();
        //whsShipment.

        content.WriteFrom(request);

        HttpClinet.Post(url + endpoint + '?oauth_consumer_key=' + consumerKey + '&oauth_token=' + accessToken
                  + '&oauth_signature_method=PLAINTEXT&oauth_signature=' + consumerSecret +
                '%26' + accessSecret, content, ResponseMessag);
        ResponseMessag.Content.ReadAs(responseText);
        exit(responseText);

    end;

}
