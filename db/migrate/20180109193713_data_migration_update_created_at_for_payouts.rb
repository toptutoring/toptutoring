class DataMigrationUpdateCreatedAtForPayouts < ActiveRecord::Migration[5.1]
  ORIGINAL_DATA =
[{ created_at: "2017-02-09 15:10:51 UTC", params: { description: "Test payment", dwolla_transfer_url: "https://api.dwolla.com/transfers/766fa8f1-d9ee-e611-80ee-02c4cfdff3c0" } },
 { created_at: "2017-02-09 18:06:44 UTC", params: { description: "Payment for 18 hrs of tutoring", dwolla_transfer_url: "https://api.dwolla.com/transfers/6e0d7b81-f2ee-e611-80ee-02c4cfdff3c0" } },
 { created_at: "2017-02-16 17:11:48 UTC",
  params: { description: "Tutoring for January and February.  Thanks!", dwolla_transfer_url: "https://api.dwolla.com/transfers/399b6d00-6bf4-e611-80ee-02c4cfdff3c0" } },
 { created_at: "2017-03-04 11:27:49 UTC", params: { description: "Tutoring advance for March.", dwolla_transfer_url: "https://api.dwolla.com/transfers/59f7fa98-cd00-e711-80f1-02c4cfdff3c0" } },
 { created_at: "2017-04-16 00:25:57 UTC",
  params:
   { description: "\r\n" + "Nicholas: 20 x 8 = 160\r\n" + "Javaria: 20 x 4.5 = 90\r\n" + "CJ: 23 x 1.5 = 34.5\r\n" + "iPad software + stylus = $27.88\r\n" + "\r\n" + "So total is: $312.38",
    dwolla_transfer_url: "https://api.dwolla.com/transfers/b7085842-3b22-e711-80f8-02c4cfdff3c0" } },
 { created_at: "2017-07-03 04:01:27 UTC",
  params: { description: "5 hours tutoring for Nicholas Stermer.  Thanks!", dwolla_transfer_url: "https://api.dwolla.com/transfers/b391ce45-a45f-e711-8103-02c4cfdff3c0" } },
 { created_at: "2017-07-03 04:02:10 UTC",
  params: { description: "Bonus for a great job and communicating well whenever things arose.", dwolla_transfer_url: "https://api.dwolla.com/transfers/bb886d62-a45f-e711-8103-02c4cfdff3c0" } },
 { created_at: "2017-07-06 13:58:03 UTC",
  params:
   { description:
     "4 hours of marketing related work. Thanks!\r\n" +
     "\r\n" +
     "Details:\r\n" +
     "\r\n" +
     "Twitter: 0.5 hours\r\n" +
     "Brexit Article+research: 2 hours\r\n" +
     "Quora+research: 1.5 hours\r\n" +
     "\r\n" +
     "Total: 4 hours",
    dwolla_transfer_url: "https://api.dwolla.com/transfers/e29a5428-5362-e711-8103-02c4cfdff3c0" } },
 { created_at: "2017-07-14 23:53:16 UTC",
  params: { description: "Payment for last two weeks of June.  Thanks!", dwolla_transfer_url: "https://api.dwolla.com/transfers/099b11a1-ef68-e711-8103-02c4cfdff3c0" } },
 { created_at: "2017-07-14 23:54:05 UTC", params: { description: "Payment for the month of July", dwolla_transfer_url: "https://api.dwolla.com/transfers/a2ad89c1-ef68-e711-8103-02c4cfdff3c0" } },
 { created_at: "2017-09-10 05:25:17 UTC", params: { description: "Jenn Park for: worked", dwolla_transfer_url: "https://api.dwolla.com/transfers/4faf8c6d-e895-e711-810a-02c4cfdff3c0" } },
 { created_at: "2017-09-10 05:25:55 UTC", params: { description: "Payment for invoices: 1.", dwolla_transfer_url: nil } },
 { created_at: "2017-09-10 05:25:55 UTC", params: { description: "Payment for invoices: 2.", dwolla_transfer_url: nil } },
 { created_at: "2017-09-10 05:29:25 UTC", params: { description: "Payment for invoices: 12, 11, 10, 13, 15, 14, 17, 18.", dwolla_transfer_url: nil } },
 { created_at: "2017-09-10 05:29:25 UTC", params: { description: "Payment for invoices: 16.", dwolla_transfer_url: nil } },
 { created_at: "2017-09-11 13:14:15 UTC", params: { description: "For month of August.  Thanks!", dwolla_transfer_url: "https://api.dwolla.com/transfers/8756cf19-f396-e711-810a-02c4cfdff3c0" } },
 { created_at: "2017-09-12 05:09:24 UTC",
  params: { description: "This is an advance for the entire tutoring project.  Thanks!", dwolla_transfer_url: "https://api.dwolla.com/transfers/f8e1a987-7897-e711-810a-02c4cfdff3c0" } },
 { created_at: "2017-09-22 22:26:32 UTC", params: { description: "Payment for invoices: 19.", dwolla_transfer_url: nil } },
 { created_at: "2017-09-22 22:26:32 UTC", params: { description: "Payment for invoices: 21, 25, 27, 28.", dwolla_transfer_url: nil } },
 { created_at: "2017-09-22 22:26:32 UTC", params: { description: "Payment for invoices: 20, 22, 23.", dwolla_transfer_url: nil } },
 { created_at: "2017-09-22 22:26:33 UTC", params: { description: "Payment for invoices: 24, 26.", dwolla_transfer_url: nil } },
 { created_at: "2017-09-25 12:51:39 UTC",
  params:
   { description: "This is to completely conclude all work on TopTutoring, etc with the final deliverable of the pillarprep design.  Thanks for your help!",
    dwolla_transfer_url: "https://api.dwolla.com/transfers/ec22b641-f0a1-e711-810a-02c4cfdff3c0" } },
 { created_at: "2017-10-02 01:23:53 UTC", params: { description: "Payment for invoices: 29, 30, 31, 40, 41, 42.", dwolla_transfer_url: nil } },
 { created_at: "2017-10-02 01:23:53 UTC", params: { description: "Payment for invoices: 32, 33.", dwolla_transfer_url: nil } },
 { created_at: "2017-10-02 01:23:53 UTC", params: { description: "Payment for invoices: 34, 35, 36, 39.", dwolla_transfer_url: nil } },
 { created_at: "2017-10-02 01:23:53 UTC", params: { description: "Payment for invoices: 37, 38.", dwolla_transfer_url: nil } },
 { created_at: "2017-10-08 03:33:24 UTC",
  params: { description: "James Hong for: 80/80 hrs for September", dwolla_transfer_url: "https://api.dwolla.com/transfers/25bac66f-d9ab-e711-810b-02c4cfdff3c0" } },
 { created_at: "2017-10-20 11:34:36 UTC", params: { description: "Payment for invoices: 43, 44, 47, 48.", dwolla_transfer_url: nil } },
 { created_at: "2017-10-20 11:34:36 UTC", params: { description: "Payment for invoices: 45, 46, 51, 52, 55, 56.", dwolla_transfer_url: nil } },
 { created_at: "2017-10-20 11:34:36 UTC", params: { description: "Payment for invoices: 49, 50, 53, 54.", dwolla_transfer_url: nil } },
 { created_at: "2017-10-31 16:26:42 UTC", params: { description: "Payment for invoices: 58, 57, 61.", dwolla_transfer_url: nil } },
 { created_at: "2017-10-31 16:26:42 UTC", params: { description: "Payment for invoices: 59, 60.", dwolla_transfer_url: nil } },
 { created_at: "2017-11-04 19:14:46 UTC", params: { description: "Payment for invoices: 63, 64, 65, 66.", dwolla_transfer_url: nil } },
 { created_at: "2017-11-04 19:14:46 UTC", params: { description: "Payment for invoices: 62.", dwolla_transfer_url: nil } },
 { created_at: "2017-11-09 23:25:24 UTC", params: { description: "Payment for invoices: 72.", dwolla_transfer_url: nil } },
 { created_at: "2017-11-15 21:58:41 UTC", params: { description: "Payment for invoices: 73, 74.", dwolla_transfer_url: nil } },
 { created_at: "2017-11-29 21:17:47 UTC", params: { description: "Payment for invoices: 76.", dwolla_transfer_url: nil } },
 { created_at: "2017-11-29 21:17:47 UTC", params: { description: "Payment for invoices: 77, 78.", dwolla_transfer_url: nil } },
 { created_at: "2017-12-01 21:14:44 UTC", params: { description: "Payment for invoices: 79.", dwolla_transfer_url: nil } },
 { created_at: "2017-12-15 23:48:29 UTC", params: { description: "Christmas Bonus Merry Christmas!", dwolla_transfer_url: "https://api.dwolla.com/transfers/b547a377-f2e1-e711-8114-02c4cfdff3c0" } },
 { created_at: "2017-12-15 23:48:44 UTC", params: { description: "Payment for invoices: 80, 83.", dwolla_transfer_url: nil } },
 { created_at: "2017-12-15 23:48:44 UTC", params: { description: "Payment for invoices: 82.", dwolla_transfer_url: nil } }]

  def up
    ORIGINAL_DATA.each do |payment|
      payout = Payout.find_by(payment[:params])
      payout.created_at = DateTime.parse(payment[:created_at])
      if payout.save
        STDOUT.puts "Updated created_at for payout #{payout.id } with #{payout.created_at }."
      else
        STDOUT.puts "Unable to update payout #{payout.id }."
      end
    end
  end
end
