require 'spec_helper'

describe Author do
  subject do
    Author.new :first_name => 'Panayotis', :last_name => 'Matsinopoulos'
  end

  it { should respond_to :disable_persistence }
  it { should respond_to :enable_persistence  }
  it { should respond_to :persistence_disabled }
  it { should respond_to :persistence_disabled? }

  describe "#disable_persistence" do
    it 'should set instance variable to correct value' do
      subject.disable_persistence
      subject.instance_variable_get(:@persistence_disabled).should be_true
    end
  end

  describe "#enable_persistence" do
    it 'should set instance variable to correct value' do
      subject.enable_persistence
      subject.instance_variable_get(:@persistence_disabled).should be_false
    end
  end

  describe '#persistance_disabled?' do
    context 'when instance variable is false' do
      before { subject.instance_variable_set(:@persistence_disabled, false) }
      it { subject.should_not be_persistence_disabled }
    end

    context 'when instance variable is true' do
      before { subject.instance_variable_set(:@persistence_disabled, true) }
      it { subject.should be_persistence_disabled }
    end
  end

  context 'when persistence disabled' do
    before { subject.disable_persistence }
    it 'should not persist' do
      subject.should be_valid
      lambda do
        subject.save.should be_false
        subject.should be_new_record
      end.should_not change {Author.count}
    end

    context 'when author is new' do
      before { subject.should be_new_record }

      it 'should not persist books either' do
        subject.should be_valid
        book = Book.new(:title => 'My Book')
        lambda do
          lambda do
            subject.books << book
            subject.should be_valid # although valid
            subject.save.should be_false # save fails due to persistence being disabled
            subject.should be_new_record
          end.should_not change {Author.count}
        end.should_not change {Book.count}
      end
    end

    context 'when author is not new' do
      before do
        subject.enable_persistence # temporarily to save subject as prerequisite of test
        lambda do
          subject.save
        end.should change { Author.count }.by(1)
        subject.should_not be_new_record
        subject.disable_persistence # Back again to disabled persistence. This is the condition under which we should test here
      end

      context 'when book has disable persistence' do
        before do
          @book = Book.new(:title => 'My Book')
          @book.disable_persistence
        end

        it 'should not persist books' do
          lambda do
            lambda do
              subject.should be_valid # make sure that the problem is not the invalidity of the subject
              subject.books << @book # this one should fail
            end.should_not change { Author.count }
          end.should_not change { Book.count }
        end
      end

      context 'when book has enable persistence' do
        before do
          @book = Book.new(:title => 'My Book')
          @book.enable_persistence
          subject.should be_persistence_disabled # just checking to make sure we have correct test assumption
        end

        it 'should persist book even if author has disabled persistence' do
          lambda do
            lambda do
              subject.should be_valid # make sure that the problem is not the invalidity of the subject
              subject.books << @book # this one should not fail
            end.should_not change { Author.count }
          end.should change { Book.count }
        end
      end
    end
  end

  context 'when persistence enabled' do
    before { subject.enable_persistence }
    it 'should persist' do
      subject.should be_valid
      lambda do
        subject.save.should be_true
        subject.should_not be_new_record
      end.should change {Author.count}.by(1)
    end

    context 'when author is new' do
      before { subject.should be_new_record }

      it 'should persist books too' do
        subject.should be_valid
        book = Book.new(:title => 'My Book')
        lambda do
          lambda do
            subject.books << book
            subject.should be_valid # although valid
            subject.save.should be_true # save succeeds because of enabled persistence
            subject.should_not be_new_record
          end.should change {Author.count}
        end.should change {Book.count}
      end
    end

    context 'when author is not new' do
      before do
        lambda do
          subject.save
        end.should change { Author.count }.by(1)
        subject.should_not be_new_record
      end

      context 'when book has disable persistence' do
        before do
          @book = Book.new(:title => 'My Book')
          @book.disable_persistence
        end

        it 'should not persist books' do
          lambda do
            lambda do
              subject.should be_valid # make sure that the problem is not the invalidity of the subject
              subject.books << @book # this one should fail
            end.should_not change { Author.count }
          end.should_not change { Book.count }
        end
      end

      context 'when book has enable persistence' do
        before do
          @book = Book.new(:title => 'My Book')
          @book.enable_persistence
        end

        it 'should persist book' do
          lambda do
            lambda do
              subject.should be_valid # make sure that the problem is not the invalidity of the subject
              subject.books << @book # this one should not fail
            end.should_not change { Author.count }
          end.should change { Book.count }
        end
      end
    end
  end

  it { subject.class.should respond_to :disable_persistence }
  it { subject.class.should respond_to :enable_persistence  }
  it { subject.class.should respond_to :persistence_disabled }
  it { subject.class.should respond_to :persistence_disabled? }

  context '#can_persist?' do
    context 'when instance persistence disabled' do
      before do
        subject.disable_persistence
        subject.persistence_disabled.should be_true
      end

      context 'when class persistence enabled' do
        before do
          subject.class.enable_persistence
          subject.class.persistence_disabled?.should be_false
        end
        it { subject.send(:can_persist?).should be_false }
      end

      context 'when class persistence disabled' do
        before do
          subject.class.disable_persistence
          subject.class.persistence_disabled?.should be_true
        end
        it { subject.send(:can_persist?).should be_false }
      end
    end

    context 'when instance persistence enabled' do
      before do
        subject.enable_persistence
        subject.persistence_disabled.should be_false
      end

      context 'when class persistence enabled' do
        before do
          subject.class.enable_persistence
          subject.class.persistence_disabled?.should be_false
        end
        it { subject.send(:can_persist?).should be_true }
      end

      context 'when class persistence disabled' do
        before do
          subject.class.disable_persistence
          subject.class.persistence_disabled?.should be_true
        end
        it { subject.send(:can_persist?).should be_false }
      end
    end
  end
end