page 50001 AWBIntegrationList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = AWBIntegration;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(track_number; track_number)
                {
                    ApplicationArea = All;

                }
                field(order_id; order_id)
                {
                    ApplicationArea = All;

                }
                field(carrier_code; carrier_code)
                {
                    ApplicationArea = All;

                }
                field(label_url; label_url)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(Update)
            {
                ApplicationArea = All;
                Description = 'Update';
                trigger OnAction();
                begin
                    Codeunit.Run(50001);
                end;

            }
        }
    }
}
