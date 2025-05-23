# timetable_projct

A new Flutter project.



 isLoading
                ? _buildLoading()
                : hasError
                ? _buildError()
                : fdata.isEmpty
                ? _buildEmpty()
                : _buildClassList(),