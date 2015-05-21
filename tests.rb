# Basic test requires
require 'minitest/autorun'
require 'minitest/pride'
require 'byebug'
# Include both the migration and the app itself
require './migration'
require './application'

# Overwrite the development database connection with a test connection.
ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: 'test.sqlite3'
)

# Gotta run migrations before we can run tests.  Down will fail the first time,
# so we wrap it in a begin/rescue.
begin ApplicationMigration.migrate(:down); rescue; end
ApplicationMigration.migrate(:up)





# Finally!  Let's test the thing.
class ApplicationTest < Minitest::Test

  def test_truth
    assert true
  end


  def test_term_can_not_be_destroyed_if_courses_present
    fall_term = Term.create(name: "Fall")
    course = Course.create(name: "Marching Band", term_id: fall_term.id)

    refute fall_term.destroy
  end


  def test_course_can_not_be_destroyed_if_course_students_present
    band_course = Course.create(name: "Marching Band")
    students = CourseStudent.create(student_id: 1, course_id: band_course.id)

    refute band_course.destroy
  end

#how do I test this????=========================================================
  def test_assignments_are_destroyed_when_courses_are_destroyed
    band_course = Course.create(name: "Marching Band")
    assignment = Assignment.create(name: "Malaguena", course_id: band_course.id )

    band_course.destroy
    assert_equal 0 , Assignment.count
  end
  # ============================================================================
  def test_stupid_one
   scales = Lesson.create(name: "Scales")
   pre = Assignment.create(name: "Read Book")
   Lesson.linked_to_assignment(pre)
   scales.update(pre_class_assignment_id: pre.id)
   assert scales.save
   assert_equal pre.id, scales.pre_class_assignment_id
 end


  def test_school_set_up
    uw = School.create(name: "University of Wyoming")
    fall_term = Term.create(name: "Fall", school_id: uw.id)
    band_course = Course.create(name: "Marching Band", course_code: "MUSC 3000", term_id: fall_term.id)
    theory_course = Course.create(name: "Music Theory", course_code: "MUSC 1050", term_id: fall_term.id)

    spring_term = Term.create(name: "Spring", school_id: uw.id)
    jazz_course = Course.create(name: "Jazz Band", course_code: "MUSC 2500", term_id: spring_term.id)
    symphony_course = Course.create(name: "Wind Symphony", course_code: "MUSC 4500", term_id: spring_term.id)

    assert uw
    assert fall_term
    assert band_course
    assert theory_course
    assert spring_term
    assert jazz_course
    assert symphony_course
  end

  def test_lessons_have_name
    scales =  Lesson.create(name: "Scales")
    assert scales


  end


  # def test_reading_has_url_order_number_and_lesson_id
  #   read =  Reading.new(order_number: nil, url:"String", lesson_id: 1)
  #
  #   assert read.save
  #   #refute read({})
  # end

  # def test_readings_start_with_proper_syntax
  #
  # end

  def method_name

  end



end
