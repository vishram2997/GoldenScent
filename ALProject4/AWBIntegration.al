table 50001 AWBIntegration
{
    caption = 'AWB Integration';
    DataPerCompany = true;

    fields
    {
        field(1; entity_id; Text[30])
        {
            Description = 'Entity_id';

        }
        field(2; parent_id; Text[30])
        {
            Description = 'parent_id';

        }
        field(3; order_id; Text[50])
        {
            Description = 'order_id';

        }
        field(4; track_number; Text[100])
        {
            Description = 'track_number';

        }
        field(5; carrier_code; Text[30])
        {
            Description = 'carrier_code';

        }

        field(6; label_url; Text[200])
        {

            Description = 'label_url';

        }
        field(7; increment_id; Text[50])
        {

            Description = 'increment_id';

        }
        field(8; whsShipmentNo; Text[50])
        {

            Description = 'whsShipmentNo';

        }

    }

    keys
    {
        key(PK; increment_id, order_id, track_number, whsShipmentNo)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}