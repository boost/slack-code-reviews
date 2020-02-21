# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command (or created
# alongside the database with db:setup).
#
# Examples:
#
#  movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#  Character.create(name: 'Luke', movie: movies.first)

workspace = SlackWorkspace.create

dnz = Project.create(name: 'dnz', slack_workspace_id: workspace.id)
natlib = Project.create(name: 'natlib', slack_workspace_id: workspace.id)
fincap = Project.create(name: 'fincap', slack_workspace_id: workspace.id)
archives = Project.create(name: 'archives', slack_workspace_id: workspace.id)
superg = Project.create(name: 'superG', slack_workspace_id: workspace.id)

Developer.create(name: 'montgomery', slack_workspace_id: workspace.id, project_id: fincap.id, slack_id: 'UA37E7Y2U')
Developer.create(name: 'gus', slack_workspace_id: workspace.id, project_id: nil, slack_id: 'U0EJ8NG4C')
Developer.create(name: 'andy', slack_workspace_id: workspace.id, project_id: nil, slack_id: 'U1F9QAFLN')
Developer.create(name: 'ben', slack_workspace_id: workspace.id, project_id: natlib.id, slack_id: 'U0EK41LTC')
Developer.create(name: 'darren', slack_workspace_id: workspace.id, project_id: nil, slack_id: 'UAVAB27HC')
Developer.create(name: 'richard', slack_workspace_id: workspace.id, project_id: dnz.id, slack_id: 'U0EJ9LUGK')
Developer.create(name: 'paul.mesnilgrente', slack_workspace_id: workspace.id, project_id: dnz.id, slack_id: 'UGZ617Y80')
Developer.create(name: 'tim', slack_workspace_id: workspace.id, project_id: natlib.id, slack_id: 'U85G63U2F')
Developer.create(name: 'eddy', slack_workspace_id: workspace.id, project_id: superg.id, slack_id: 'U0EJEBQ2K')
Developer.create(name: 'katherine', slack_workspace_id: workspace.id, project_id: archives.id, slack_id: 'UCP9K4ABS')
Developer.create(name: 'yar', slack_workspace_id: workspace.id, project_id: archives.id, slack_id: 'U0UBDP0G2')
Developer.create(name: 'oliver', slack_workspace_id: workspace.id, project_id: superg.id, slack_id: 'U21GUK6AF')
Developer.create(name: 'jonathan', slack_workspace_id: workspace.id, project_id: nil, slack_id: 'UFE2L09SS')
Developer.create(name: 'dave.harris', slack_workspace_id: workspace.id, project_id: dnz.id, slack_id: 'UT3TBKTV4')
