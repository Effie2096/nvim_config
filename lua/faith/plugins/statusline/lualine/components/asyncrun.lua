return {
	function()
		return table.concat(vim.tbl_values(vim.tbl_map(function(job)
			if job.status == "running" then
				return "⏳"
			end
			return (job.status == "success" and "✅" or "❌")
		end, vim.g.asyncrun_job_status or {})))
	end,
}
