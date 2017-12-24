RSpec.describe SqlFormatterWebInterface do
  describe '#format' do
    let(:sql) { '' }
    let(:options) { { reindent: true, keyword_case: :upper } }

    subject { SqlFormatterWebInterface.new(sql).format(options) }

    context 'with a reachable url' do
      it "returns a String" do
        expect(SqlFormatterWebInterface.new('').format).to be_a String
      end
      context 'with a valid sql' do
        let(:sql) do
          <<-SQL
select user_id, count(*) as how_many from bboard where
                   not exists (select 1 from bboard_authorized_maintainers bam
                   where bam.user_id = bboard.user_id) and posting_time + 60 > sysdate
                   group by user_id order by how_many desc;
                   SQL
        end
        it "returns a formatted sql" do
          expected_output = <<-SQL
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
          expect(subject).to eq expected_output
        end
      end
      context 'with an invalid sql' do
        let(:sql) { 'invalid blah blah blah!' }

        it "returns the same string as the input" do
          expect(subject).to eq sql
        end
      end
    end
  end
end
