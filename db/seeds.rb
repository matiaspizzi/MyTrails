# Idempotent seeds for development.
# Run with: bin/rails db:seed

require "open-uri"

def attach_avatar(user)
  return if user.profile_image.attached?
  url = "https://api.dicebear.com/9.x/initials/png?seed=#{user.name}+#{user.surname}&backgroundColor=202837&textColor=9fef00"
  user.profile_image.attach(
    io: URI.open(url),
    filename: "#{user.name.downcase}_avatar.png",
    content_type: "image/png"
  )
end

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
  # Dave (emp1) — 7 objectives
  { employee: employees[0], title: "Complete onboarding modules",        description: "Finish all required onboarding training materials.",             status: :Done,        estimated_completion_at: 2.months.from_now, rated_by: leader1.id, rating: 4 },
  { employee: employees[0], title: "Q1 performance self-assessment",     description: "Submit self-assessment form before the review deadline.",         status: :In_Review,   estimated_completion_at: 1.week.from_now },
  { employee: employees[0], title: "Improve API response time by 20%",   description: "Profile and optimize the main API endpoints.",                   status: :In_Progress, estimated_completion_at: 3.weeks.from_now },
  { employee: employees[0], title: "Refactor authentication module",      description: "Extract auth logic into a dedicated concern and add tests.",      status: :New,         estimated_completion_at: 1.month.from_now },
  { employee: employees[0], title: "Database index review",               description: "Identify and add missing indexes on high-traffic queries.",       status: :In_Progress, estimated_completion_at: 2.weeks.from_now },
  { employee: employees[0], title: "Upgrade Ruby version",                description: "Migrate the app from Ruby 3.1 to 3.3 and fix deprecations.",      status: :Done,        estimated_completion_at: 3.months.from_now,    rated_by: leader1.id, rating: 5 },
  { employee: employees[0], title: "Write integration tests for billing", description: "Cover the full billing flow with request specs.",                 status: :New,         estimated_completion_at: 5.weeks.from_now },

  # Eve (emp2) — 7 objectives
  { employee: employees[1], title: "Deliver landing page redesign",       description: "Implement the new design approved in Figma.",                    status: :New,         estimated_completion_at: 1.month.from_now },
  { employee: employees[1], title: "Write unit tests for auth module",    description: "Achieve ≥90% coverage on the authentication concern.",           status: :In_Progress, estimated_completion_at: 2.weeks.from_now },
  { employee: employees[1], title: "Document REST API endpoints",         description: "Add OpenAPI annotations to all public endpoints.",               status: :In_Review,   estimated_completion_at: 4.days.from_now },
  { employee: employees[1], title: "Implement dark mode",                 description: "Add a theme toggle and persist preference in localStorage.",      status: :New,         estimated_completion_at: 6.weeks.from_now },
  { employee: employees[1], title: "Fix mobile navigation bugs",          description: "Resolve reported issues with the hamburger menu on iOS Safari.",  status: :Done,        estimated_completion_at: 1.month.from_now,     rated_by: leader1.id, rating: 3 },
  { employee: employees[1], title: "Reduce bundle size",                  description: "Audit JS dependencies and remove unused packages.",               status: :In_Progress, estimated_completion_at: 3.weeks.from_now },
  { employee: employees[1], title: "Set up error monitoring",             description: "Integrate Sentry and configure alerting rules.",                  status: :Done,        estimated_completion_at: 2.months.from_now, rated_by: leader1.id, rating: 4 },

  # Frank (emp3) — 7 objectives
  { employee: employees[2], title: "Set up CI/CD pipeline",              description: "Configure GitHub Actions for automated testing and deploys.",     status: :Done,        estimated_completion_at: 1.month.from_now,     rated_by: leader2.id, rating: 5 },
  { employee: employees[2], title: "Migrate legacy reports to CSV",      description: "Replace PDF export with CSV for the reports section.",            status: :New,         estimated_completion_at: 6.weeks.from_now },
  { employee: employees[2], title: "Container security hardening",       description: "Apply CIS Docker benchmarks to all production images.",           status: :In_Progress, estimated_completion_at: 2.weeks.from_now },
  { employee: employees[2], title: "Infrastructure cost audit",          description: "Review cloud spend and identify savings opportunities.",           status: :In_Review,   estimated_completion_at: 1.week.from_now },
  { employee: employees[2], title: "Automate database backups",          description: "Schedule and verify daily Postgres backups to S3.",               status: :Done,        estimated_completion_at: 3.months.from_now,    rated_by: leader2.id, rating: 4 },
  { employee: employees[2], title: "Load testing report",               description: "Run k6 load tests and document bottlenecks found.",               status: :In_Progress, estimated_completion_at: 4.weeks.from_now },
  { employee: employees[2], title: "Rotate production secrets",         description: "Update all API keys and environment secrets per security policy.", status: :New,         estimated_completion_at: 2.months.from_now },

  # Grace (emp4) — 7 objectives
  { employee: employees[3], title: "Audit accessibility compliance",     description: "Run axe-core on all pages and fix WCAG AA violations.",           status: :In_Progress, estimated_completion_at: 3.weeks.from_now },
  { employee: employees[3], title: "Client demo preparation",           description: "Prepare slides and demo environment for Q2 client meeting.",       status: :In_Review,   estimated_completion_at: 3.days.from_now },
  { employee: employees[3], title: "Onboard two new team members",      description: "Run onboarding sessions and set up dev environments for joiners.", status: :Done,        estimated_completion_at: 6.weeks.from_now,     rated_by: leader2.id, rating: 5 },
  { employee: employees[3], title: "Update employee handbook",          description: "Revise handbook sections affected by the new remote policy.",      status: :New,         estimated_completion_at: 1.month.from_now },
  { employee: employees[3], title: "Q2 OKR alignment workshop",        description: "Facilitate team workshop to align individual objectives with OKRs.",status: :In_Review,   estimated_completion_at: 5.days.from_now },
  { employee: employees[3], title: "Vendor contract renewals",         description: "Review and renew three SaaS contracts before expiry.",             status: :Done,        estimated_completion_at: 1.month.from_now,     rated_by: leader2.id, rating: 3 },
  { employee: employees[3], title: "Implement feedback survey",        description: "Build and launch the quarterly employee satisfaction survey.",      status: :In_Progress, estimated_completion_at: 2.weeks.from_now },
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

# ── Avatars ───────────────────────────────────────────────────────────────────

([admin, leader1, leader2] + employees).each { |u| attach_avatar(u) }

puts "Seeded:"
puts "  #{User.count} users (admin@mytrails.dev, leader1@mytrails.dev, leader2@mytrails.dev, emp1-4@mytrails.dev)"
puts "  #{Leadership.count} leaderships"
puts "  #{Objective.count} objectives"
puts "All passwords: password"
