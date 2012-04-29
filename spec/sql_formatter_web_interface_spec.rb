require 'spec_helper'

# I am online if I can reach Google
def online?
  open('http://www.google.com')
  true
rescue SocketError
  false
end

module SqlFormatterWebInterface
  describe SqlFormatterWebInterface do
    before(:each) do
      raise Exception, "it seems you're not online: check your internet connection" unless online?
    end
    describe '::format' do
      context 'with a reachable url' do
        it "returns a String" do
          SqlFormatterWebInterface.format('').class.should == String
        end
        context 'with a valid sql' do
          it "returns a formatted sql" do
            input = <<-SQL.strip
                     select user_id, count(*) as how_many from bboard where 
                     not exists (select 1 from bboard_authorized_maintainers bam 
                     where bam.user_id = bboard.user_id) and posting_time + 60 > sysdate 
                     group by user_id order by how_many desc;
                     SQL
            expected_output = <<-SQL.unindent.strip
                              SELECT user_id,
                                     count(*) AS how_many
                              FROM bboard
                              WHERE NOT EXISTS
                                  (SELECT 1
                                   FROM bboard_authorized_maintainers bam
                                   WHERE bam.user_id = bboard.user_id)
                                AND posting_time + 60 > sysdate
                              GROUP BY user_id
                              ORDER BY how_many DESC;
                              SQL
            SqlFormatterWebInterface.format(input).should == expected_output
          end
        end
        context 'with an invalid sql' do
          it "returns the same string as the input one" do
            input = 'invalid blah blah blah!'
            SqlFormatterWebInterface.format(input).should == input
          end
        end
      end
      context 'with an unreachable url' do
        it "raises a SocketError" do
          unreachable_url = 'http://this.is.an.unreachable.url'
          proc { SqlFormatterWebInterface.format('', :url => unreachable_url) }.should raise_error SocketError, "unable to resolve #{unreachable_url}"
        end
      end
    end
  end
end