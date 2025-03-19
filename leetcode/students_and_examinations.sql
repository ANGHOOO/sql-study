SELECT
    st.student_id,
    st.student_name,
    sub.subject_name,
    COUNT(ex.subject_name) AS attended_exams
FROM
    Students AS st
    CROSS JOIN Subjects AS sub
    LEFT JOIN Examinations ex
    ON st.student_id = ex.student_id
    AND sub.subject_name = ex.subject_name
GROUP BY
    st.student_id,
    st.student_name,
    sub.subject_name
ORDER BY
    student_id, subject_name

    
