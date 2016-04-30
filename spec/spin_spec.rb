describe Spin do
  describe '#group_name' do
    it 'works with at symbol' do
      spin = Spin.new(team_id: 1, group_name: '@some_group')

      expect(spin.group_name).to eq('some_group')
    end

    it 'works without at symbol' do
      spin = Spin.new(team_id: 1, group_name: 'some_group')

      expect(spin.group_name).to eq('some_group')
    end
  end
end
