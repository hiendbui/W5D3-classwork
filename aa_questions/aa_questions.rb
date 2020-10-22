require "sqlite3"
require "singleton"

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User
    attr_accessor :id, :fname,:lname

    def self.find_by_id(usr_id)
        user = QuestionsDatabase.instance.execute(<<-SQL, usr_id)
            SELECT
              *
            FROM
              users
            WHERE
              id = ?;
        SQL

        return nil if user.empty?
        User.new(user.first)
    end

    def self.find_by_name(first_name, last_name)
        user = QuestionsDatabase.instance.execute(<<-SQL, first_name, last_name)
            SELECT
              *
            FROM
              users
            WHERE
              fname = ? AND lname = ?;
        SQL

        return nil if user.empty?
        User.new(user.first)
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def authored_questions
        Question.find_by_author_id(id)
    end

    def authored_replies
        Reply.find_by_user_id(id)
    end

end

class Question
    attr_accessor :id, :title, :body, :author_id 

    def self.find_by_id(qstn_id)
        question = QuestionsDatabase.instance.execute(<<-SQL, qstn_id)
            SELECT
              *
            FROM
              questions
            WHERE
              id = ?;
        SQL

        return nil if question.empty?
        Question.new(question.first)
    end

    def self.find_by_author_id(author_id)
        questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
              *
            FROM
              questions
            WHERE
              author_id = ?;
        SQL

        return nil if question.empty?
        questions.map { |question| Question.new(question) }
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def author
        User.find_by_id(author_id)
    end

    def replies
        Reply.find_by_question_id(id)
    end
end

class QuestionFollow
    attr_accessor :id, :question_id, :user_id 

    def self.find_by_id(q_fllw_id)
        question_follow = QuestionsDatabase.instance.execute(<<-SQL, q_fllw_id)
            SELECT
              *
            FROM
              question_follows
            WHERE
              id = ?;
        SQL

        return nil if question_follow.empty?
        QuestionFollow.new(question_follow.first)
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end
end

class Reply
    attr_accessor :id, :body, :reply_id, :question_id, :user_id 

    def self.find_by_id(rply_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, rply_id)
            SELECT
              *
            FROM
              replies
            WHERE
              id = ?;
        SQL

        return nil if reply.empty?
        Reply.new(reply.first)
    end

    def self.find_by_user_id(usr_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, usr_id)
            SELECT
              *
            FROM
              replies
            WHERE
              user_id = ?;
        SQL

        return nil if reply.empty?
        Reply.new(reply.first)
    end

    def self.find_by_question_id(qstn_id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, qstn_id)
            SELECT
              *
            FROM
              replies
            WHERE
              question_id = ?;
        SQL

        return nil if reply.empty?
        replies.map { |reply| Reply.new(reply) }
    end

    def initialize(options)
        @id = options['id']
        @body = options['body']
        @reply_id = options['reply_id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

    def author  
        User.find_by_id(user_id)
    end

    def question
        Question.find_by_id(question_id)
    end    

    def parent_reply
        Reply.find_by_id(reply_id)
    end

    def child_reply
        replies = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
              *
            FROM
              replies
            WHERE
              reply_id = ?;
        SQL

        return nil if reply.empty?
        replies.map { |reply| Reply.new(reply) }
    end
end

class QuestionLike
    attr_accessor :id, :question_id, :user_id 

    def self.find_by_id(like_id)
        like = QuestionsDatabase.instance.execute(<<-SQL, like_id)
            SELECT
              *
            FROM
              question_likes
            WHERE
              id = ?;
        SQL

        return nil if like.empty?
        QuestionLike.new(like.first)
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end
end