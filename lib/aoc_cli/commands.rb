module AocCli
	module Commands
		class KeyStore
			attr_reader :user, :key
			def initialize(args)
				args = defaults.merge(args).compact
				@user, @key = args[:user], args[:key]
			end
			def exec
				Files::Cookie.new(u:user).store(k:key)
				self
			end
			def respond
				puts "Key added successfully"
			end
			def defaults
				{user:Files::Config.new.def_acc}
			end
		end
		class YearInit
			attr_reader :user, :year
			def initialize(args)
				args = defaults.merge(args).compact
				@user, @year = args[:user], args[:year]
			end
			def exec
				Year::Init
					.new(u:user, y:year)
					.write
				Year::Stars
					.new(u:user, y:year)
					.write.update_meta
				self
			end
			def respond
				puts "Year initialised"
			end
			def defaults
				{user:Files::Config.new.def_acc}
			end
		end
		class DayInit
			attr_reader :user, :year, :day
			def initialize(args)
				args  = defaults.merge(args).compact
				@user = args[:user]
				@year = args[:year]
				@day  = args[:day]
			end
			def exec
				Day::Init
					.new(u:user, y:year, d:day)
					.mkdir.write
				Day::Files
					.new(u:user, y:year, d:day)
					.write
				self
			end
			def defaults
				{user:Metafile.get(:user), 
				 year:Metafile.get(:year)}
			end
			def respond
				puts "Day #{day} initialised"
			end
		end
		class DaySolve
			attr_reader :user, :year, :day, :part, :ans
			def initialize(args)
				args  = defaults.merge(args).compact
				@user = args[:user]
				@year = args[:year]
				@day  = args[:day]
				@part = args[:part]
				@ans  = args[:ans]
			end
			def exec 
				Solve::Attempt
					.new(u:user, y:year, d:day, p:part, a:ans)
					.respond
				self
			end
			def respond
				"REsponse"
			end
			def defaults
				{user:Metafile.get(:user),
				 year:Metafile.get(:year),
				  day:Metafile.get(:day),
				 part:Metafile.get(:part)}
			end
		end
		class OpenReddit
			attr_reader :year, :day
			def initialize(args)
				@year = args[:year] ||= Metafile.get(:year)
				@day  = args[:day]  ||= Metafile.get(:day)
			end
			def exec
				Day::Reddit.new(y:year, d:day).open
				self
			end
			def respond
			end
		end
		class SetDefaultUser
			def initialize(args)
				@user = Validate.user(args[:user])
			end
			def exec
				Files::Config.new.mod_line(key:"default")
			end
			def respond
				puts "Default account succesfully changed to #{user.yellow}"
			end
		end
		class Refresh
			attr_reader :dir
			def initialize(args)
				@dir = Metafile.type
			end
			def exec
				case dir
				when :DAY  then Day.refresh
				when :ROOT then Year.refresh
				end
				#when :ROOT then Year::Stars.new.write.update_meta
				self
			end
			def respond
			end
		end
		class DayAttempts
			attr_reader :user, :year, :day, :part
			def initialize(args)
				args = defaults.merge(args).compact
				@user = args[:user]
				@year = args[:year]
				@day  = args[:day]
				@part = args[:part]
			end
			def exec
				Day::AttemptsTable
					.new(u:user, y:year, d:day, p:part)
					.show
				self
			end
			def respond

			end
			def defaults
				{user:Metafile.get(:user),
				 year:Metafile.get(:year),
				  day:Metafile.get(:day),
				 part:Metafile.get(:part)}
			end
		end
	end
end
