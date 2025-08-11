report 50116 "ORE Send Message Auto"
{
    // CS060 Leon 2023/10/18 - One Renesas EDI

    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        ORESendMessage."Send Message_ALL"();
        //MESSAGE('Send message all completed');
    end;

    var
        ORESendMessage: Codeunit "ORE Send Message";
}

