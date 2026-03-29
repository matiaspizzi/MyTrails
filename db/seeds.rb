# Idempotent seeds for development.
# Run with: bin/rails db:seed

# ── Users ────────────────────────────────────────────────────────────────────

admin = User.find_or_create_by!(email_address: "admin@mytrails.dev") do |u|
  u.name       = "Alice"
  u.surname    = "Admin"
  u.password   = "password"
  u.role       = :admin
  u.confirmed_at = Time.current
end

leader1 = User.find_or_create_by!(email_address: "leader1@mytrails.dev") do |u|
  u.name       = "Bob"
  u.surname    = "Leader"
  u.password   = "password"
  u.role       = :leader
  u.confirmed_at = Time.current
end

leader2 = User.find_or_create_by!(email_address: "leader2@mytrails.dev") do |u|
  u.name       = "Carol"
  u.surname    = "Leader"
  u.password   = "password"
  u.role       = :leader
  u.confirmed_at = Time.current
end

employees = [
  { email_address: "emp1@mytrails.dev", name: "Dave",  surname: "Smith"  },
  { email_address: "emp2@mytrails.dev", name: "Eve",   surname: "Jones"  },
  { email_address: "emp3@mytrails.dev", name: "Frank", surname: "Brown"  },
  { email_address: "emp4@mytrails.dev", name: "Grace", surname: "Taylor" },
].map do |attrs|
  User.find_or_create_by!(email_address: attrs[:email_address]) do |u|
    u.name         = attrs[:name]
    u.surname      = attrs[:surname]
    u.password     = "password"
    u.role         = :employee
    u.confirmed_at = Time.current
  end
end

# ── Leaderships ───────────────────────────────────────────────────────────────

Leadership.find_or_create_by!(leader: leader1, employee: employees[0])
Leadership.find_or_create_by!(leader: leader1, employee: employees[1])
Leadership.find_or_create_by!(leader: leader2, employee: employees[2])
Leadership.find_or_create_by!(leader: leader2, employee: employees[3])

# ── Objectives ────────────────────────────────────────────────────────────────

objectives_data = [
  { employee: employees[0], title: "Complete onboarding modules",       description: "Finish all required onboarding training materials.",          status: :Done,        estimated_completion_at: 2.months.ago,  rated_by: leader1.id, rating: 4 },
  { employee: employees[0], title: "Q1 performance self-assessment",    description: "Submit self-assessment form before the review deadline.",      status: :In_Review,   estimated_completion_at: 1.week.from_now },
  { employee: employees[0], title: "Improve API response time by 20%",  description: "Profile and optimize the main API endpoints.",                status: :In_Progress, estimated_completion_at: 3.weeks.from_now },
  { employee: employees[1], title: "Deliver landing page redesign",     description: "Implement the new design approved in Figma.",                 status: :New,         estimated_completion_at: 1.month.from_now },
  { employee: employees[1], title: "Write unit tests for auth module",  description: "Achieve ≥90% coverage on the authentication concern.",        status: :In_Progress, estimated_completion_at: 2.weeks.from_now },
  { employee: employees[1], title: "Document REST API endpoints",       description: "Add OpenAPI annotations to all public endpoints.",            status: :In_Review,   estimated_completion_at: 4.days.from_now },
  { employee: employees[2], title: "Set up CI/CD pipeline",            description: "Configure GitHub Actions for automated testing and deploys.", status: :Done,        estimated_completion_at: 1.month.ago,   rated_by: leader2.id, rating: 5 },
  { employee: employees[2], title: "Migrate legacy reports to CSV",    description: "Replace PDF export with CSV for the reports section.",        status: :New,         estimated_completion_at: 6.weeks.from_now },
  { employee: employees[3], title: "Audit accessibility compliance",   description: "Run axe-core on all pages and fix WCAG AA violations.",       status: :In_Progress, estimated_completion_at: 3.weeks.from_now },
  { employee: employees[3], title: "Client demo preparation",         description: "Prepare slides and demo environment for Q2 client meeting.",  status: :In_Review,   estimated_completion_at: 3.days.from_now },
]

objectives_data.each do |attrs|
  Objective.find_or_create_by!(
    employee: attrs[:employee],
    title:    attrs[:title]
  ) do |o|
    o.description            = attrs[:description]
    o.status                 = attrs[:status]
    o.estimated_completion_at = attrs[:estimated_completion_at]
    o.rated_by               = attrs[:rated_by]
    o.rating                 = attrs[:rating]
  end
end

puts "Seeded:"
puts "  #{User.count} users (admin@mytrails.dev, leader1@mytrails.dev, leader2@mytrails.dev, emp1-4@mytrails.dev)"
puts "  #{Leadership.count} leaderships"
puts "  #{Objective.count} objectives"
puts "All passwords: password"
