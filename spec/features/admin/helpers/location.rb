shared_context :location do
  let(:location) do
    location = create(:location)
    user.locations << location
    location
  end
end
